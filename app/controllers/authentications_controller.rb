class AuthenticationsController < ApplicationController
  skip_authentication
  set_tab :authentications, :content_nav

  before_action -> { content_nav "devise/registrations/content_nav" }

  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    authentication = Authentication.find_or_create_by_omniauth(request.env["omniauth.auth"])
    authentication.save

    if current_user
      if authentication.user
        if authentication.user == current_user
          flash[:notice] = "That #{authentication.provider_display_name} account is already connected to your account."
        else
          flash[:error] = "That #{authentication.provider_display_name} account is already connected to a different account, so I can't connect it to yours."
        end
      else
        # If there's a user signed in already, we're just going to add this oauth account to the user
        current_user.authentications << authentication
        current_user.save
        flash[:success] = "Added your #{authentication.provider_display_name} account!"
      end
      redirect_to authentications_url

    elsif authentication.user
      # If this account has previously signed in, we know which user account to sign in
      flash[:success] = "Logged in using #{authentication.provider_display_name}. Welcome!"
      sign_in_and_redirect(:user, authentication.user)

    else
      # This is a new authentication
      # Go to the registration form, keeping the omniauth data available for afterward.
      # The GET param is necessary because the registration page is the same controller/action and branches based on
      # the presense of the GET param. By allowing it to be removed from the URL, we don't continue to assume that
      # they're still trying to authenticate this way. Place it in the session for security, since nobody can fake
      # that, right?
      session[:omniauth_authentication_id] = authentication.id

      if User.find_by_email(authentication.info.email)
        flash[:info] = "There's already a account with the email address you use with #{authentication.provider_display_name}."
        redirect_to new_user_session_path(:omniauth_authentication_id => authentication.id)
      else
        redirect_to new_user_registration_path(:omniauth_authentication_id => authentication.id)
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:success] = "Removed your #{@authentication.provider_display_name} credentials."
    redirect_to authentications_url
  end
end
