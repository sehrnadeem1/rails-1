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
    @user = User.new(configure_sign_up_params)
    if @user.save
      flash[:notice] = "Waiter successfully created."
    else
      flash[:alert] = "Waiter could not be created beacuse: #{@user.errors.full_messages}."
    end
    respond_to do |format|
      format.html { redirect_to waiters_path }
    end
  end

  protected
  def configure_sign_up_params
    params.require(:user).permit(:email, :name, :password)
  end

end
