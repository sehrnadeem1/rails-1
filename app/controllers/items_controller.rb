class ItemsController < ApplicationController
  load_and_authorize_resource

  #POST /items/:id
  def create
    if @item.save
      respond_to do |format|
        flash[:notice] = 'Item successfully added.'
        format.html { redirect_to @item }
      end
    else
      flash.now[:alert] = 'Item could not be created.'
      respond_to do |format|
        format.html { render 'new' }
      end
    end
  end

  #PUT /items/:id
  def update
    if @item.update(item_params)
      respond_to do |format|
        flash[:notice] = 'Item successfully updated.'
        format.html { redirect_to @item }
      end
    else
      flash.now[:alert] = 'Item could not be updated.'
      respond_to do |format|
        format.html { render 'edit' }
      end
    end
  end

  #DELETE /items/:id
  def destroy
    if @item.destroy
      flash[:notice] = 'Item successfully deleted'
    else
      flash[:alert] = 'Item could not be deleted'
    end
    respond_to do |format|
      format.html { redirect_to items_path }
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :quantity, :price)
  end
end
