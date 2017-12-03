class WaitersController < ApplicationController

  #GET /waiters
  def index
    if current_user.admin?
      @waiters = User.all.order(created_at: :desc).paginate(page: params[:page], per_page: LISTING_PAGINATION_SIZE)
       respond_to do |format|
        format.html
      end
    end
  end

  def edit
    @waiter = User.find_by(id: params[:id])
    respond_to do |format|
      format.html
    end
  end

  def update
    success = false
    @waiter = User.find_by(id: params[:id])
    if @waiter.present? && @waiter.update(waiter_params)
      success = true
      flash[:notice] = I18n.t(:waiter_update_success)
    else
      flash[:alert] = I18n.t(:waiter_update_fail, error: @waiter.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html do
        if success
          redirect_to waiters_path
        else
          render 'edit'
        end
      end
    end
  end

  def destroy
    @waiter = User.find_by(id: params[:id])
    if @waiter.present? && @waiter.destroy
      flash[:notice] = I18n.t(:waiter_delete_success)
    else
      flash[:alert] = I18n.t(:waiter_delete_fail, error: @waiter.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html { redirect_to waiters_path }
    end
  end

  private
  def waiter_params
    params.require(:user).permit(:email, :name, :password)
  end

end
