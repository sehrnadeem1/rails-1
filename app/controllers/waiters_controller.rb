class WaitersController < ApplicationController

  #GET /waiters
  def index
    if current_user.admin?
      @waiters = User.waiter.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
       respond_to do |format|
        format.html
      end
    end
  end

  def edit
    @waiter = User.find_by(id: params[:id])
  end

  def update
    @waiter = User.find_by(id: params[:id])
    if @waiter.update(waiter_params)
      flash[:notice] = I18n.t(:waiter_update_success)
      redirect_to waiters_path
    else
      flash[:alert] = I18n.t(:waiter_update_fail, error: @waiter.errors.full_messages.to_sentence)
      render 'edit'
    end
  end

  def destroy
    @waiter = User.find_by(id: params[:id])
    if @waiter.destroy
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
