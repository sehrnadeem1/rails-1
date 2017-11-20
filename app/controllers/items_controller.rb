class ItemsController < ApplicationController
	load_and_authorize_resource

	def create 								#POST /items/:id
		if @item.save
			respond_to do |format|
    		format.html { redirect_to @item, notice: 'Item successfully added.' }
 			end
		else
			flash.now[:alert] = 'Item could not be created.'
			respond_to do |format|
    		format.html { render 'new' }
			end
		end
	end

	def update 								#PUT /items/:id
		if @item.update(item_params)
			respond_to do |format|
				format.html { redirect_to @item, notice: 'Item successfully updated.' }
			end
		else
			flash.now[:alert] = 'Item could not be updated.'
			respond_to do |format|
    		format.html { render 'edit' }
    	end
		end
	end

	def destroy 							#DELETE /items/:id
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
