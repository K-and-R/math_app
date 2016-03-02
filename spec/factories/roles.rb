# Read about Faker at https://github.com/stympy/faker
require 'faker'

# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :role do
    name { "role_#{rand(9999)}" }

    factory :admin_role, parent: :role do
      name "admin"
    end
    
  end
end
