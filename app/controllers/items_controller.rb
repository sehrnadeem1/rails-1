class ItemsController < ApplicationController
  load_and_authorize_resource

  #GET /items
  def index
    @items = Item.active
    @items = @items.order(created_at: :desc).paginate(page: params[:page], per_page: LISTING_PAGINATION_SIZE)
    respond_to do |format|
      format.html
    end
  end

  #POST /items/
  def create
    success = false
    if success = @item.save
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
    if success = @item.update(item_params)
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
    if @item.destroy || @item.update(active: false)
      flash[:notice] = I18n.t(:item_delete_success)
    else
      flash[:alert]  = @item.errors.full_messages
    end

    respond_to do |format|
      format.html { redirect_to items_path }
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :quantity, :price, :image)
  end
end
