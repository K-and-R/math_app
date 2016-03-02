class ApplicationController < ActionController::Base
  include UrlHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :make_action_mailer_use_request_host

  # Entire app requires authentication
  # Require all controllers to authorize the user for the current action.
  # If a controller doesn't, you'll get an exception.
  check_authorization unless: :skip_authorization?
  before_action :require_login
  after_action :store_location

  ##
  # If an Access Denies exception is raised, do this instead of showing the results of an uncaught exception.
  rescue_from CanCan::AccessDenied, with: :render_access_denied
  rescue_from SecurityError, with: :render_access_denied

  def routing_error
    fail ActionController::RoutingError.new 'Page not found'
  end

  protected

  def ensure_json_request
    return if json_request?
    render_access_denied
  end

  def json_request?
    !!(
      request.xhr? ||
      request.headers["Accept"] =~ /json/ ||
      params[:format] == "json" ||
      request.format == Mime::JSON
    )
  end

  def content_nav(template = nil)
    @content_nav_template = template || 'content_nav'
  end

  def make_action_mailer_use_request_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def user_timezone
    cookies['time_zone'] || 'US/Eastern'
  end

  def set_timezone
    Time.zone = user_timezone
  end

  def flash_message(type, message)
    flash[type] = message
  end

  ########
  # Authentication and Authorization
  #
  def self.skip_authentication(*args)
    skip_before_action :require_login, *args
    skip_before_action :require_no_authentication, *args
  end

  def require_login
    unless logged_in?
      if json_request?
        render_error(:access_denied)
      else
        store_location
        redirect_to login_path
      end
    end
  end

  def logged_in?
    !!current_user
  end

  ##
  # Checks for a user being logged in and makes sure they're an admin.
  def authenticate_admin!
    authenticate_user!
    fail SecurityError unless current_user.admin?
  end

  def skip_authorization?
    # Within our own controllers, it's important that authorization
    # be left enabled so that we never forget to either call
    # authorize_resource or authorize! within each action. The
    # ActiveAdmin authorization adapter does not call authorize!, even
    # though it does use CanCan to check authorization and filter
    # records. So we must not require it to.
    # We also want to skip this for Devise.
    kind_of?(ActiveAdmin::BaseController) || respond_to?(:devise_controller?)
  end

  ########
  # Redirection
  #

  # REF: https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
  # Store location for redirection
  def store_location
    # store last url as long as it is an HTTP GET and isn't a login or logout path
    session[:return_to_path] = request.fullpath if storable_request?
  end

  def storable_request?
    # only GETs and not ignored paths
    !!(request.get? && !ignored_paths.include?(request.path))
  end

  def return_to_path
    session[:return_to_path] if valid_return_to_path?
  end

  def valid_return_to_path?
    !!(
      session.key?(:return_to_path) &&
      !session[:return_to_path].blank? &&
      ignored_paths.include?(
        URI.parse(session[:return_to_path]).path
      )
    )
  end

  def ignored_paths
    [
      root_path,
      user_registration_path,
      new_user_registration_path,
      cancel_user_registration_path,
      register_path,
      user_session_path,
      new_user_session_path,
      login_path,
      destroy_user_session_path,
      logout_path,
      user_password_path,
      new_user_password_path,
      user_confirmation_path,
      new_user_confirmation_path,
      user_unlock_path,
      new_user_unlock_path
    ]
  end

  def user_path(user)
    user.admin? ? admin_dashboard_path : dashboard_path
  end

  def after_sign_up_path_for(user)
    return_to_path || signed_in_root_path(resource)
  end

  def after_sign_in_path_for(user)
    return_to_path || signed_in_root_path(resource)
  end

  def signed_in_root_path(user)
    return_to_path || user_path(user)
  end

  def after_sign_out_path_for(user)
    login_path
  end

  def after_update_path_for(user)
    logged_in? ? (return_to_path || profile_path) : root_path
  end

  def auth_failure(user)
    redirect_to(return_to_path || root_path)
  end

  #######
  # Error handling
  #

  unless Rails.application.config.consider_all_requests_local
    rescue_from(
      Exception,
      with: ->(exception) { render_error :internal_server_error, 500, exception }
    )
    rescue_from(
      ActionController::RoutingError,
      ActionController::UnknownController,
      ::AbstractController::ActionNotFound,
      ActiveRecord::RecordNotFound,
      with: ->(exception) { render_error :not_found, 404, exception }
    )
    rescue_from(
      SecurityError,
      CanCan::AccessDenied,
      with: ->(exception) { render_error :access_denied, 403, exception }
    )
  end

  def render_access_denied
    render_error :access_denied, 403
  end

  def render_not_found
    render_error :not_found, 404
  end

  def render_error(type, code = 500,  exception = nil)
    # Send exception to Sentry
    capture_exception(exception) if exception
    Rails.logger.error(
      "Rendering error '#{type.to_s}' because of #{exception.class}: "\
      "#{exception.message}"
    ) if exception
    respond_to do |format|
      format.html { render status: code, template: "errors/#{type.to_s}", layout: 'error' }
      format.json { render status: code, text: { error: type.to_s.titleize }.to_json, content_type: Mime::JSON }
      format.text { render status: code, text: type.to_s.titleize }
    end
  end
end
