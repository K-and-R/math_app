class InvitationsController < ApplicationController

  def accept
    @token = params[:token]
    @user = User.find_by_invite_token(@token)
  end

protected

  def after_invitation_path_for( user )
    if signed_in?
      signed_in_root_path(user)
    else
      new_session_path(user)
    end
  end

end
