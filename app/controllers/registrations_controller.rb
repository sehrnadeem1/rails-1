class RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
skip_before_filter :require_no_authentication, only: [:new, :create]

  # GET /resource/sign_up
  def new
    #super
    @user = User.new
    respond_to do |format|
        format.html
    end
  end

  # POST /resource
  def create
    #super
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

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected
  def configure_sign_up_params
    params.require(:user).permit(:email, :name, :password)
  end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
