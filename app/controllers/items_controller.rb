class ItemsController < ApplicationController
  load_and_authorize_resource

  #GET /items
  def index
    @items = @items.order(created_at: :desc).paginate(page: params[:page], per_page: LISTING_PAGINATION_SIZE)
    @items = @items.where(active: true)
    respond_to do |format|
      format.html
    end
  end

  #POST /items/
  def create
    success = false
    if @item.save
      success = true
      flash[:notice] = I18n.t(:item_create_success)
    else
      flash.now[:alert] = I18n.t(:item_create_fail, error: @item.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html do
        if success
          redirect_to @item
        else
          render 'new'
        end
      end
    end
  end

  #PUT /items/:id
  def update
    success = false
    if @item.update(item_params)
      success = true
      flash[:notice] = I18n.t(:item_update_success)
    else
      flash.now[:alert] = I18n.t(:item_update_fail, error: @item.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html do
        if success
          redirect_to @item
        else
          render 'edit'
        end
      end
    end
  end

  #DELETE /items/:id
  def destroy
    item_found, item_deleted = false, false
    item_found = true if OrderItem.joins(:item).where(items: {name: @item.name}).any?

    if item_found
      item_deleted = true if @item.update(active: false)
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
