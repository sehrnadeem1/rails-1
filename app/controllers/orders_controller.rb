class OrdersController < ApplicationController
  before_action :parse_datetime, only: [:create, :update]
  load_and_authorize_resource :order

  #GET /user/:user_id/orders
  def index
    if params[:search_field].present? && params[:search_value].present?
      if params[:search_field] == 'waiter'
        @orders = Order.where(user_id: params[:search_value].to_i)
      elsif params[:search_field] == 'status'
        @orders = Order.where(status: params[:search_value])
      end
    end
    @orders = @orders.order(created_at: :desc).paginate(page: params[:page], per_page: LISTING_PAGINATION_SIZE)
    respond_to do |format|
      format.html
    end
  end

  #POST /user/:user_id/orders
  def create
    success = false
    @order.user = current_user
    if @order.save
      success = true
      flash[:notice] = I18n.t(:order_create_success)
    else
      flash.now[:alert] = I18n.t(:order_create_fail, error: @order.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html do
        if success
          redirect_to user_order_path(current_user, @order)
        else
          render 'new'
        end
      end
    end
  end

  #PUT /user/:user_id/orders/:id
  def update
    success = false
    if @order.update(order_params)
      success = true
      flash[:notice] = I18n.t(:order_update_success)
    else
      flash.now[:alert] = I18n.t(:order_update_fail, error: @order.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html do
        if success
          redirect_to user_order_path(current_user, @order)
        else
          render 'edit'
        end
      end
    end
  end

  #DELETE /user/:user_id/orders/:id
  def destroy
    if @order.destroy
      flash[:notice] = I18n.t(:order_delete_success)
    else
      flash[:alert] = I18n.t(:order_delete_fail, error: @order.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html { redirect_to orders_path }
    end
  end

  def search
    @search_field = params[:search_field]
    @values = ''
    if @search_field == 'waiter'
      @values = User.waiter
    elsif @search_field == 'status'
      @values = Order::STATUS
    end
    respond_to do |format|
      format.js
    end
  end

  private
  def order_params
    params.require(:order).permit(:status, :description, :delivery_time)
  end

  def parse_datetime
    if params[:order][:delivery_time].class != DateTime && params[:order][:delivery_time].present?
      params[:order][:delivery_time] = DateTime.strptime(params[:order][:delivery_time],'%m/%d/%Y %I:%M %p')
    end
  end
end
