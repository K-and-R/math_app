require 'rubygems'

def run_at_startup
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start

  require 'simplecov'
  SimpleCov.start 'rails'

  ENV['RAILS_ENV'] ||= 'test'

  require File.dirname(__FILE__) + '/../config/environment.rb'

  require 'rspec/rails'
  require 'database_cleaner'
  require 'rails/application'
  require 'rails/all'

  if ENV["SPORK_ENV"]
    Spork.trap_method(Rails::Application, :reload_routes!)
    Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  end

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    config.include(ActionDispatch::TestProcess)
    config.include(MailerMacros)
    config.include(JavascriptMacros)
    config.include Rails.application.routes.url_helpers

    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = 'random'

    # RSpec Rails can automatically mix in different behaviours to your tests
    # based on their file location, for example enabling you to call `get` and
    # `post` in specs under `spec/controllers`.
    #
    # You can disable this behaviour by removing the line below, and instead
    # explictly tag your specs with their type, e.g.:
    #
    #     describe UsersController, :type => :controller do
    #       # ...
    #     end
    #
    # The different available types are documented in the features, such as in
    # https://relishapp.com/rspec/rspec-rails/v/3-0/docs
    config.infer_spec_type_from_file_location!

    config.before(:each) do
      Capybara.app_host = URI::Generic.build(Rails.application.routes.default_url_options.merge({scheme: 'http'})).to_s
    end
  end
end

if ENV["SPORK_ENV"]
  require 'spork'

  Spork.prefork do
    require 'rspec/autorun'
    
    # Loading more in this block will cause your tests to run faster. However,
    # if you change any configuration or code from libraries loaded here, you'll
    # need to restart spork for it take effect.
    run_at_startup
  end

  Spork.each_run do
    # This code will be run each time you run your specs.
    FactoryGirl.reload

    # To reload config/locales/*
    I18n.backend.reload!
  end
else
  run_at_startup
end

#Include Custom App Helpers
include LayoutHelper
include ApplicationHelper
include ErrorMessagesHelper
