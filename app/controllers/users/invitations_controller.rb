class Users::InvitationsController < Devise::InvitationsController
  def edit
    redirect_to user_omniauth_authorize_path(:dwolla)
  end
end
