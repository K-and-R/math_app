require 'spec_helper'

describe Phone do

  it "has a valid factory" do
    FactoryGirl.create(:phone).should be_valid
  end

  it "is invalid without a user" do
    FactoryGirl.build(:phone, user: nil).should_not be_valid
  end

  it "does not require a type" do
    FactoryGirl.build(:phone, user: FactoryGirl.create(:user)).should be_valid
  end

  it "does not allow duplicate phone numbers per user" do
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:phone, user: user, number: '555-555-5555', type: 'mobile')
    FactoryGirl.build(:phone, user: user, number: '555-555-5555', type: 'home').should_not be_valid
  end

end
