class DashboardController < ApplicationController
  skip_authorization_check
  set_tab :dashboard
  before_filter :require_login

  def index
  end
end
