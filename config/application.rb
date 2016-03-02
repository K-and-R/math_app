require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'validation_skipper'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Require some initializers that might be needed by other initializers
# ...in this specific order
%w(
  nil
  string
  hash
  open_struct
  time
  inflections
).each do |filename|
  require File.expand_path("../initializers/#{filename}.rb", __FILE__)
end

module MathApp
  class Application < Rails::Application
    config.from_file 'settings.yml'
    config.encoding = "utf-8"
    I18n.enforce_available_locales = false
    config.filter_parameters += [:password]

    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.consider_all_requests_local       = !!Rails.configuration.app.consider_requests_local

    # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
    if Rails.configuration.app.force_ssl
      config.force_ssl = true
      config.to_prepare { Devise::SessionsController.force_ssl }
      config.to_prepare { Devise::RegistrationsController.force_ssl }
      config.to_prepare { Devise::PasswordsController.force_ssl }
    end
    config.action_mailer.delivery_method = Rails.configuration.email.delivery_method.to_sym

    host_options = { host: Rails.configuration.app.fqdn }
    config.action_mailer.default_url_options = host_options
    Rails.application.routes.default_url_options.merge!(host_options)

    config.log_level = Rails.configuration.app.log_level.to_sym

    def name
      Rails.configuration.app.name
    end
  end
end
