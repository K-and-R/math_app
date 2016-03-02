if Rails.configuration.sentry.present? && Rails.configuration.sentry.dsn
  require 'raven'

  begin
    uri = URI.parse(Rails.configuration.sentry.dsn)
    Raven.configure do |config|
      config.dsn = uri.to_s
      uri.password = nil
      Rails.configuration.sentry.javascript_dsn =  uri.to_s if Rails.configuration.sentry.javascript_enabled
    end
  rescue URI::InvalidURIError
    raise "Invalid Rails.configuration.sentry.dsn: #{Rails.configuration.sentry.dsn}"
  end
end
