# Read about Faker at https://github.com/stympy/faker
require 'faker'

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone_type do
    sequence(:name) {|n| "phone_type_#{n}"}
  end
end
