class HomeController < ApplicationController
  skip_authentication
  skip_authorization_check

  set_tab :about, :main_nav, only: :about
  set_tab :contact, :main_nav, only: :contact

  set_tab :privacy, :footer_links, only: :privacy
  set_tab :terms, :footer_links, only: :terms
  set_tab :help, :footer_links, only: :help

  def index
  end

  def subdomain_specific_index
    render :index
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def terms
  end

  def help
  end
end
