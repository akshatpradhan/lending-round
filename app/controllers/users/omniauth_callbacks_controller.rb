class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def dwolla
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_dwolla_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted? && @user.invitation_accepted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Dwolla") if is_navigational_format?
    else
      User.accept_invitation!(invitation_token: @user.invitation_token)
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Dwolla") if is_navigational_format?
    end
  end
end

