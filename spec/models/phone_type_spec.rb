require 'spec_helper'

describe PhoneType do

  it "has a valid factory" do
    FactoryGirl.create(:phone_type).should be_valid
  end

end
