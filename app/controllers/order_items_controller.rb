class OrderItemsController < ApplicationController
  load_and_authorize_resource :order
  load_and_authorize_resource :order_item, through: :order

  #GET /order/:order_id/order_items
  def index
    @order_items = @order_items.order(created_at: :desc).paginate(page: params[:page], per_page: 4)
    respond_to do |format|
      format.html
    end
  end

  #GET /order/:order_id/order_items/new
  def new
    @items = Item.where(active: true)
    respond_to do |format|
      format.js
    end
  end

  #GET /order/:order_id/order_items/:id/edit
  def edit
    @items = Item.where(active: true)
    respond_to do |format|
      format.html
    end
  end

  #POST /order/:order_id/order_items
  def create
    @items = Item.where(active: true)
    create_success = false
    if @order_item.item.quantity >= @order_item.quantity
      OrderItem.transaction do
        if @order_item.save
          @order_item.item.update(quantity: (@order_item.item.quantity - @order_item.quantity))
          create_success = true
        end
      end
    else
      @order_item.errors.add(:quantity, I18n.t(:order_item_quantity_error))
    end
    respond_to do |format|
      format.js do
       render action: "failure" unless create_success
      end
    end
  end

  #PUT /order/:order_id/order_items/:id
  def update
    @items = Item.where(active: true)
    if check_updated_quantity
      if @order_item.update(order_item_params)
        respond_to do |format|
          flash[:notice] = I18n.t(:order_item_update_success)
          format.html { redirect_to [@order, @order_item] }
        end
      else
        flash.now[:alert] = I18n.t(:order_item_update_fail, error: @order_item.errors.full_messages.to_sentence)
        respond_to do |format|
          format.html { render 'edit' }
        end
      end
    else
      flash.now[:alert] = I18n.t(:order_item_update_quantity_error)
      respond_to do |format|
        format.html { render 'edit' }
      end
    end
  end

  #DELETE /order/:order_id/order_items/:id
  def destroy
    if @order_item.order.status != 'Completed'

      if @order_item.destroy
        flash[:notice] = I18n.t(:order_item_delete_success)
        @order_item.item.update(quantity: @order_item.item.quantity + @order_item.quantity)

      else
        flash[:alert] = I18n.t(:order_item_delete_fail, error: @order_item.errors.full_messages.to_sentence)
      end
    else
      flash[:alert] = I18n.t(:order_item_destroy_status_error)
    end
    respond_to do |format|
      format.html { redirect_to order_order_items_path(@order) }
    end
  end

  private
  def order_item_params
    params.require(:order_item).permit(:item_id, :quantity)
  end

  def check_updated_quantity
    if @order_item.item.id == params[:order_item][:item_id].to_i
      if (params[:order_item][:quantity]).to_i > @order_item.quantity
        quantity_diff  = @order_item.item.quantity - (params[:order_item][:quantity].to_i - @order_item.quantity)
      else
        quantity_diff  = @order_item.item.quantity + (@order_item.quantity - params[:order_item][:quantity].to_i)
      end
      @order_item.item.update(quantity: quantity_diff)
    else
      new_item = Item.find_by(id: params[:order_item][:item_id].to_i)
      if new_item.present?
        if new_item.update(quantity: new_item.quantity - params[:order_item][:quantity].to_i)
          @order_item.item.update(quantity: @order_item.item.quantity + @order_item.quantity)
          true
        else
          false
        end
      else
        false
      end
    end
  end

end
