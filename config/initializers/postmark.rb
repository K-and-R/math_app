if Rails.configuration.postmark.api_key.present?
  Rails.application.config.action_mailer.postmark_settings = { api_key: Rails.configuration.postmark.api_key }
end
