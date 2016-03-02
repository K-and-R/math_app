source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.3'

# Configuration management (settings.yml and settings.local.yml)
gem 'choices'

gem 'mysql2', '~> 0.3.20'
gem 'mysql_stay_connected'

gem 'pg'

# DSL for writing SQL queries in Ruby
gem 'squeel', '>= 1.2.3'

# Allow for db:data:dump and db:data:load rake tasks
gem 'yaml_db', github: 'K-and-R/yaml_db'

# Commandline option parser, for CLI scripts
gem 'trollop'

group :development do
  # Generators
  gem 'nifty-generators'

  # View and CSS updates
  gem 'rack-livereload'
  gem 'guard-livereload'

  # Suppress asset pipline log messages
  gem 'quiet_assets'

  # debugging
  gem 'better_errors'

  # UML ERD diagrams
  gem 'railroady'

  # Interaction with RailsPanel Chrome extension
  gem 'meta_request'
end

group :test do
  # Browser testing
  gem 'capybara'
  gem 'capybara-email'
  gem 'capybara-screenshot'

  # Selenuim (Headless Firefox browser) for testing
  gem 'selenium-webdriver'

  # PhantomJS (Headless Webkit browser) for testing
  gem 'poltergeist'

  # Open browser on failed integration tests
  gem 'launchy'

  # Preload Rails env for testing
  gem 'spork-rails'

  # Run RSpec on file changes
  gem 'guard-rspec'
  gem 'guard-spork'

  # Clean DB for each test
  gem 'database_cleaner'

  # Provide an easier syntax for unit tests
  gem 'shoulda-matchers'
  gem 'cucumber-rails', require: false

  # Code test coverage reporting
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false
end

group :development, :test do
  # Factory generator
  gem 'factory_girl_rails', require: false

  # Generate placeholder data for factories
  gem 'faker', require: false

  # RSpec for rails
  gem 'rspec-rails', require: false
  gem 'rspec-rerun', require: false

  # Email preview
  gem 'letter_opener'

  # Code formatting/style Checking
  gem 'scss_lint', github: 'brigade/scss-lint', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false

  # Deploy with Capistrano
  gem 'capistrano', '>= 3.1.0', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-passenger', github: 'capistrano/passenger', require: false
  gem 'capistrano-npm', require: false
  gem 'capistrano-grunt', github: 'roots/capistrano-grunt', require: false
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq', require: false
  gem 'capistrano-maintenance', github: "capistrano/maintenance", require: false
end

group :production, :staging do
  # New Relic monitoring
  gem 'newrelic_rpm'

  # 12-Factor for Rails 3 or 4 (12factor.net)
  gem 'rails_12factor'
end

# Console (not just developmnet because someitme we need a console in other environments)
gem 'pry-rails'
gem 'pry-plus', github: 'K-and-R/pry-plus'
gem 'awesome_print'

gem 'sprockets'

# Application Administration
gem 'activeadmin', github: 'activeadmin'
gem 'active_admin_importable', github: 'K-and-R/active_admin_importable'

# Style
gem 'bootstrap-sass'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 5.0'
gem 'compass-rails'
gem 'bourbon'
gem 'zocial-rails', github: 'jeffleeismyhero/Zocial-Rails'
gem 'autoprefixer-rails'

# JS frameworks
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-cookie-rails'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '>= 4.1.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Rails variables in JS
gem 'gon'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 2.0'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '>= 3.1.0'

# View templating
gem 'slim-rails'
gem 'handlebars_assets'
gem 'tabs_on_rails'
gem 'social-buttons', github: 'K-and-R/social-buttons'
gem 'rack-pjax'

#  Model form generation
gem 'simple_form', '>= 3.0.0'
gem 'simple_form_bootstrap3'

#  Model observers for code triggers
gem 'rails-observers'

# RESTful services mapped to ruby models
gem 'activeresource'

# Use unicorn as the app server
gem 'unicorn'

# Error reporting
gem 'sentry-raven', github: 'getsentry/raven-ruby'

# Authentication
gem 'devise'
# Social Auth
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-github'
gem 'omniauth-yahoo'
gem 'omniauth-openid'

# Authorization
gem 'rolify'
gem 'cancancan'

# Email validation
gem 'email_validator', github: 'karlwilbur/email_validator', :require => 'email_validator/strict'

# Skip validation option
gem 'validation_skipper', github: 'karlwilbur/validation_skipper', :require => 'validation_skipper'

# Easy Gravatar integration
gem 'gravatar_image_tag'

# Change tracking for all models.
gem 'paper_trail', '>= 3.0.0'

# Tags
gem 'acts-as-taggable-on'

# Image uploading and management to S3, Rackspace Files, etc.
gem 'aws-sdk', '~> 1.0'
gem 'carrierwave'
gem 'carrierwave-aws'

gem 'nested_form'
gem 'socialization'
gem 'meta-tags', require: 'meta_tags'
gem 'figaro', '>= 0.5.0'
gem 'default_value_for'
gem 'country_select'
gem 'just-datetime-picker'
gem 'google-analytics-rails'
gem 'rails_config'
gem 'friendly_id'
gem 'mailboxer'

# Postmark email service
gem 'postmark-rails', '>= 0.4.1'

# Response caching
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'

# Background job queue (uses Redis)
gem 'sidekiq'
gem 'sinatra', require: false # for Sidekiq web

# Datepicker Control for Bootstrap
gem 'bootstrap-datepicker-rails'
#gem 'bootstrap-timepicker-rails' # Uses LESS
gem 'jquery-timepicker-rails'

# Country/Region selectors for Rails
gem 'carmen-rails'
