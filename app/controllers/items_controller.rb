class ItemsController < ApplicationController
  load_and_authorize_resource

  #GET /items
  def index
    @items = @items.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    @items = @items.where(active: true)
    respond_to do |format|
      format.html
    end
  end

  #POST /items/
  def create
    if @item.save
      respond_to do |format|
        flash[:notice] = I18n.t(:item_create_success)
        format.html { redirect_to @item }
      end
    else
      flash.now[:alert] = I18n.t(:item_create_fail, error: @item.errors.full_messages.to_sentence)
      respond_to do |format|
        format.html { render 'new' }
      end
    end
  end

  #PUT /items/:id
  def update
    if @item.update(item_params)
      respond_to do |format|
        flash[:notice] = I18n.t(:item_update_success)
        format.html { redirect_to @item }
      end
    else
      flash.now[:alert] = I18n.t(:item_update_fail, error: @item.errors.full_messages.to_sentence)
      respond_to do |format|
        format.html { render 'edit' }
      end
    end
  end

  #DELETE /items/:id
  def destroy
    item_found, item_deleted = false, false
    orders = Order.all
    orders.each do |order|
      orderItems = order.order_items
      orderItems.each do |orderItem|
        item_found = true if orderItem.item == @item
      end
    end

    if item_found
      item_deleted = true if @item.update(active: 0)
    else
      item_deleted = true if @item.destroy
    end

    if item_deleted
      flash[:notice] = I18n.t(:item_delete_success)
    else
      flash[:alert] = I18n.t(:item_delete_fail, error: @item.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html { redirect_to items_path }
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :quantity, :price, :item_image)
  end
end
