# Be sure to restart your server when you modify this file.

Rails.application.configure do
  # Configure static asset server for tests with Cache-Control for performance.
  config.static_cache_control = 'public, max-age=3600'

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = Rails.configuration.assets.version

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js print.css )
  config.assets.precompile += %w( print.css )

  # Disable Rails's static file server (Apache or nginx will already do this).
  # Enable Rails's static file server on Heroku.
  config.serve_static_files = !!Rails.configuration.assets.serve_static_files

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = !!Rails.configuration.assets.compile

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true
end
