# Read about Faker at https://github.com/stympy/faker
require 'faker'

# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  sequence(:email) {|n| "user#{n}@example.com" }

  factory :user do
    # required
    #email { FactoryGirl.generate(:email) }
    email { Faker::Internet.safe_email }
    
    # Devise
    password { Faker::Internet.password }
    password_confirmation { |u| u.password }

    confirmed_at Time.now
    
    # This will use the User class (Admin would have been guessed)
    factory :admin_user, parent: :user do
      email { Faker::Internet.safe_email('admin') }
      after(:create) do |user|
        user.add_role(:admin)
        user.save
      end
    end

  end
end
