# Be sure to restart your server when you modify this file.

if Rails.configuration.cookie_domain.present?
  Rails.application.config.session_store :cookie_store, key: "_#{Rails.configuration.app.name.downcase}_session", domain: Rails.configuration.cookie_domain
else
  Rails.application.config.session_store :cookie_store, key: "_#{Rails.configuration.app.name.downcase}_session", domain: :all
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Rails.application.config.session_store :active_record_store
