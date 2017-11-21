class OrdersController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :order

  #GET /user/:user_id/orders
  def index
    if @user.waiter?
      @orders = @user.orders
      respond_to do |format|
        format.html
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end

  #POST /user/:user_id/orders
  def create
    if current_user.admin?
      @order.user = current_user
    end
    if @order.save
      respond_to do |format|
        flash[:notice] = 'Order successfully created.'
        format.html { redirect_to user_order_path(@user, @order) }
      end
    else
      flash.now[:alert] = "Order could not be created."
      respond_to do |format|
        format.html { render 'new' }
      end
    end
  end

  #PUT /user/:user_id/orders/:id
  def update
    if @order.update(order_params)
      respond_to do |format|
        flash[:notice] = 'Order successfully updated.'
        format.html { redirect_to user_order_path(@user, @order) }
      end
    else
      flash.now[:alert] = 'Order could not be updated.'
      respond_to do |format|
        format.html { render 'edit' }
      end
    end
  end

  #DELETE /user/:user_id/orders/:id
  def destroy
    if @order.destroy
      flash[:notice] = "Order deleted."
    else
      flash[:alert] = "Order could not be deleted."
    end
    respond_to do |format|
      format.html { redirect_to user_orders_path(@user) }
    end
  end

  private
  def order_params
    params.require(:order).permit(:status, :description, :delivery_time)
  end
end
