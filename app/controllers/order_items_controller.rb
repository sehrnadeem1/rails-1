class OrderItemsController < ApplicationController
  load_and_authorize_resource :order
  load_and_authorize_resource :order_item, through: :order

  #GET /order/:order_id/order_items/new
  def new
    @items = Item.all
    respond_to do |format|
      format.js
    end
  end

  #GET /order/:order_id/order_items/:id/edit
  def edit
    @items = Item.all
    respond_to do |format|
      format.html
    end
  end

  #POST /order/:order_id/order_items
  def create
    @items = Item.all
    if @order_item.item.quantity >= @order_item.quantity
      OrderItem.transaction do
        if @order_item.save
          @order_item.item.update(quantity: (@order_item.item.quantity - @order_item.quantity))
          flash[:notice] = 'Order item successfully added.'
          respond_to do |format|
            format.js
          end
        else
          flash[:alert] = "Order item could not be added beacuse of #{@order_item.errors.full_messages}."
          respond_to do |format|
            format.js
          end
        end
      end
    else
      flash[:alert] = 'Order item quantity cannot be greater than item stock quantity.'
      respond_to do |format|
        format.js
        end
    end
  end

  #PUT /order/:order_id/order_items/:id
  def update
    @items = Item.all
    if check_updated_quantity
      if @order_item.update(order_item_params)
        respond_to do |format|
          flash[:notice] = 'Order item successfully updated.'
          format.html { redirect_to [@order, @order_item] }
        end
      else
        flash.now[:alert] = 'Order item could not be updated.'
        respond_to do |format|
          format.html { render 'edit' }
        end
      end
    else
      flash[:alert] = 'Order items could not be updated, not enough items in stock.'
      respond_to do |format|
        format.html { render 'edit' }
      end
    end
  end

  #DELETE /order/:order_id/order_items/:id
  def destroy
    if @order_item.destroy
      flash[:notice] = 'Order item successfully deleted.'
    else
      flash[:alert] = 'Order item could not be deleted.'
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
    if (params[:order_item][:quantity]).to_i > @order_item.quantity
      quantity_diff  = @order_item.item.quantity - (params[:order_item][:quantity].to_i - @order_item.quantity)
    else
      quantity_diff  = @order_item.item.quantity + (@order_item.quantity - params[:order_item][:quantity].to_i)
    end
    @order_item.item.update(quantity: quantity_diff)
  end
end
