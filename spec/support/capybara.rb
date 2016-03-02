require 'capybara/rspec'
require 'capybara/email/rspec'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    js_errors: true,
    inspector: true,
    phantomjs_options: ['--load-images=yes', '--ignore-ssl-errors=yes'],
    timeout: 120
  })
end

RSpec.configure do |config|
  config.include(Capybara::DSL)
  config.include(Capybara::Email::DSL)
end

Capybara.configure do |config|
  # config.javascript_driver = :selenium
  config.javascript_driver = :poltergeist
  config.server_host = Rails.application.routes.default_url_options[:host]
  config.server_port = Rails.application.routes.default_url_options[:port]
  config.always_include_port = true
  config.run_server = true
end

RSpec::Matchers::define :have_link_or_button do |text|
  match do |page|
    Capybara.string(page.body).has_selector?(:link_or_button, text: text)
  end
end

# TODO: Spend some tine to figure out why this isn't working. --KJW
# module Capybara
#   module Screenshot
#     def self.screenshot_and_open_image
#       require "launchy"
#       saver = Saver.new(Capybara, Capybara.page, false)
#       saver.save
# binding.pry
#       raise IOError.new "File '#{saver.screenshot_path}' not found." unless File.exists? saver.screenshot_path
#       uri = "file://#{saver.screenshot_path}"
#       Launchy.open uri
#       {:html => nil, :image => saver.screenshot_path, :image_uri => uri}
#     end
#   end
# end
