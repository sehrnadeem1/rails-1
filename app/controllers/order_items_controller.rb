class OrderItemsController < ApplicationController
	load_and_authorize_resource :order
	load_and_authorize_resource :order_item, through: :order

	def new 									#GET    /order/:order_id/order_items/new
		@items = Item.all
		respond_to do |format|
  		format.js
  		format.html
		end
	end

	def edit 									#GET    /order/:order_id/order_items/:id/edit
		@items = Item.all
		respond_to do |format|
  		format.html
		end
	end

	def create 								#POST   /order/:order_id/order_items
		@items = Item.all
		if @order_item.item.quantity >= @order_item.quantity
			if @order_item.save
				@order_item.item.update(quantity: (@order_item.item.quantity - @order_item.quantity))
				flash[:notice] = 'Order item successfully added.'
				respond_to do |format|
					format.js
  				format.html { redirect_to [@order, @order_item] }
				end
			else
				flash[:alert] = "Order item could not be added beacuse of #{@order_item.errors.full_messages}."
				respond_to do |format|
					format.js
  				format.html { render 'new' }
				end
			end
		else
			flash[:alert] = 'Order item quantity cannot be greater than item stock quantity.'
			respond_to do |format|
					format.js
  				format.html { render 'new' }
				end
		end
	end

	def update 								#PUT    /order/:order_id/order_items/:id
		@items = Item.all
		if check_updated_quantity
			if @order_item.update(order_item_params)
				respond_to do |format|
  				format.html { redirect_to [@order, @order_item], notice: 'Order item successfully updated.' }
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

	def destroy								#DELETE /order/:order_id/order_items/:id
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
			quantity_diff  = params[:order_item][:quantity].to_i - @order_item.quantity
			@order_item.item.update(quantity: @order_item.item.quantity - quantity_diff)
		else
			quantity_diff  = @order_item.quantity - params[:order_item][:quantity].to_i
			@order_item.item.update(quantity: @order_item.item.quantity + quantity_diff)
		end
	end
end
