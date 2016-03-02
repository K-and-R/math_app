# Read about Faker at https://github.com/stympy/faker
require 'faker'

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone do
    
    user_id { Faker::Number.number(4) }
    
    number { Faker::PhoneNumber.phone_number }
    
    phone_type_id { Faker::Number.number(4) }
  
  end
end
