# Read about factories at https://github.com/thoughtbot/factory_girl
require 'factory_girl_rails'
# Read about Faker at https://github.com/stympy/faker
require 'faker'

# Required after loading Faker gem ...for now.
# See: https://github.com/stympy/faker/issues/285
I18n.reload!

RSpec.configure do |config|
  config.include(FactoryGirl::Syntax::Methods)
  # additional factory_girl configuration
  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
    begin
      DatabaseCleaner.start
      # FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each, js: true) do
    self.use_transactional_fixtures = false
    ActiveRecord::Base.establish_connection
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
    ActiveRecord::Base.establish_connection
  end
  config.after(:each, js: true) do
    DatabaseCleaner.clean
    ActiveRecord::Base.establish_connection
    self.use_transactional_fixtures = true
    DatabaseCleaner.strategy = :transaction
  end
end
