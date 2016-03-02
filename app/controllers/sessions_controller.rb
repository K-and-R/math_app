class SessionsController < Devise::SessionsController
  skip_authentication only: [:new, :create, :cancel, :destroy]
  skip_authorization_check only: [:new, :create, :cancel, :destroy]

  set_tab :login, :user_nav

  ##
  # Override method so that we can use a different view script if in the middle of OAuth authentication
  def new
    # Note that we're NOT calling super, since we need to respond differently depending on
    # whether we're in an OAuth signup
    self.resource = build_resource

    clean_up_passwords(resource)

    @form_url = session_path(resource_name, :omniauth_authentication_id => params[:omniauth_authentication_id])
    @new_registration_url = new_registration_path(resource_name, :omniauth_authentication_id => params[:omniauth_authentication_id])

    respond_with(resource, serialize_options(resource)) do |format|
      # If creating a new account based on OAuth, switch to the simpler view.
      if currently_creating_oauth_account?
        @form_url = session_path(resource_name, :omniauth_authentication_id => params[:omniauth_authentication_id])
        @new_registration_url = new_registration_path(resource_name, :omniauth_authentication_id => params[:omniauth_authentication_id])
      end
    end
  end

  def create
    super

    if currently_creating_oauth_account?
      authentication = Authentication.find(session[:omniauth_authentication_id])
      # Add the authentication to the newly created user.
      resource.authentications << authentication
      resource.save
    end
  end

  private

  def build_resource
    self.resource = resource_class.new(sign_in_params)

    # If they were in the middle of signing in with OAuth but had to log in.
    if currently_creating_oauth_account?
      @authentication = Authentication.find(session[:omniauth_authentication_id])
      # Add the authentication to the unsaved user. This will cause it to take on the email address by default.
      resource.authentications << @authentication
    end

    resource
  end

  ##
  # Determines whether the user is in the process of creating a new account using their Omniauth account.
  # Ensures that the user's session includes the same information as the GET param, so that it can't be spoofed.
  def currently_creating_oauth_account?
    if params.has_key? :omniauth_authentication_id
      session[:omniauth_authentication_id] == params[:omniauth_authentication_id].to_i
    end
  end
end
