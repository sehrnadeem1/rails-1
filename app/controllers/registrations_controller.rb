class RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
skip_before_filter :require_no_authentication, only: [:new, :create]

  # GET /resource/sign_up
  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  # POST /resource
  def create
    success = false
    @user = User.new(configure_sign_up_params)
    if @user.save
      success = true
      flash[:notice] = I18n.t(:waiter_create_success)
    else
      flash[:alert] = I18n.t(:waiter_create_fail, error: @user.errors.full_messages.to_sentence)
    end
    respond_to do |format|
      format.html do
        if success
          redirect_to waiters_path
        else
          render 'new'
        end
      end
    end
  end

  protected
  def configure_sign_up_params
    params.require(:user).permit(:email, :name, :password)
  end

end
