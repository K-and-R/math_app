require 'spec_helper'
require 'factory_girl_rails'

# Validate all factories.
# FactoryGirl.find_definations to not have to require files individually

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
     it 'is valid' do
      expect(build(factory_name)).to be_valid, -> { factory.errors.full_messages.join("\n") }
     end
  end
end

RSpec.configure do |config|
  config.include(FactoryGirl::Syntax::Methods)
end