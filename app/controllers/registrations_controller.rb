class RegistrationsController < Devise::RegistrationsController
  skip_authentication only: [:new, :create, :cancel]

  before_action :content_nav
  set_tab :register, :user_nav
  set_tab :profile, :content_nav, only: :profile
  set_tab :email, :content_nav, only: :edit
  set_tab :password, :content_nav, only: :change_password

  ##
  # Override method so that we can use a different view script if in the middle of OAuth authentication
  def new
    # Note that we're NOT calling super, since we need to respond differently depending on
    # whether we're in an OAuth signup
    resource = build_resource({})

    @form_url = user_registration_path
    @new_session_url = new_user_session_path

    if currently_creating_oauth_account?
      @form_url = user_registration_path(omniauth_authentication_id: params[:omniauth_authentication_id])
      @new_session_url = new_user_session_path(omniauth_authentication_id: params[:omniauth_authentication_id])
    else
      respond_with resource
    end
  end

  ##
  # Override method so that we can clear the session only when the user has been saved.
  def create
    if resource.save!
      if currently_creating_oauth_account?
        # Clean up the authentication ID in the session
        session[:omniauth_authentication_id] = nil
      end

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, "signed_up_but_#{resource.inactive_message}".to_sym if is_navigational_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, bypass: true
      redirect_to after_update_path_for(@user)
    else
      render 'edit'
    end
  end

  def profile
    @user = User.find(current_user.id)
    unless params['user'].nil?
      @user.update(params['user'])
      if @user.save
        flash.now[:info] = 'You profile has been updated.'
      else
        flash.now[:error] = 'You profile failed to save.'
      end
    end
  end

  def change_password
    @user = User.find(current_user.id)

    unless params['user'].nil?
      if params['user']['current_password'].blank?
        @user.errors[:current_password] = 'Current password cannot be blank.'
      elsif @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
        set_flash_message :notice, :updated
        redirect_to after_update_path_for(@user)
      end
    end
  end

  ##
  # Override this method so that we can remove the password_confirmation field
  # http://stackoverflow.com/questions/2795313/disable-password-confirmation-during-registration-when-using-devise
  # and make the password field optional when signing up using OAuth.
  def password_required?
    !persisted? || !password.nil? || !currently_creating_oauth_account?
  end

  def edit
    set_tab :account, :subnav
    render :edit
  end

  protected

  private

  def build_resource(*args)
    res = super
    # Handle creation of a new account if they were in the middle of signing in with OAuth but had to
    # use the Registration form to provide complete information.
    if currently_creating_oauth_account?
      @authentication = Authentication.find(session[:omniauth_authentication_id])
      # Add the authentication to the new user
      res.authentications << @authentication
    end
    res
  end

  def resource
    @resource ||= build_resource(sign_up_params)
  end

  ##
  # Determines whether the user is in the process of creating a new account using their Omniauth account.
  # Ensures that the user's session includes the same information as the GET param, so that it can't be spoofed.
  def currently_creating_oauth_account?
    session[:omniauth_authentication_id] == params[:omniauth_authentication_id].to_i if params.key? :omniauth_authentication_id
  end

  # check if we need password to update user data
  # ie if password was changed
  def needs_password?(user, params)
    params[:user][:password].present?
  end
end
