require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it "is not an admin by default" do
    expect(@user.admin?).to be_falsey
  end

  it "can be an admin" do
    expect(FactoryGirl.create(:admin_user).admin?).to be_truthy
  end

  describe "validations" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:user)).to be_valid
    end

    it "rejects a nil email address" do
      expect(FactoryGirl.build(:user, email: nil)).to_not be_valid
    end

    it "rejects a nil email address" do
      expect(FactoryGirl.build(:user, email: '')).to_not be_valid
    end

    it "rejects invalid email addresses" do
      addresses = %w[
        user@foo,com
        user_at_foo.org
        example.user@foo.
        example.@foo.com
        example@.foo.com
      ]
      addresses.each do |address|
        expect(FactoryGirl.build(:user, email: address)).to_not be_valid
      end
    end

    it "accepts valid email addresses" do
      addresses = %w[
        user@foo.com
        user@foo.jp
        user@foo.travel
        user@foo.museum
        user@foo.local
        THE_USER@foo.bar.org
        first-last@foo.com
        first_last@foo.com
        first+last@foo.com
        a@a.com
      ]
      # user@localhost # left out because Devise doesn't like it.
      addresses.each do |address|
        expect(FactoryGirl.build(:user, email: address)).to be_valid
      end
    end

    it "rejects duplicate email addresses" do
      @user_one = FactoryGirl.create(:user)
      expect(FactoryGirl.build(:user, email: @user_one.email)).to_not be_valid
    end

    it "rejects email addresses identical up to case" do
      @user_one = FactoryGirl.create(:user)
      expect(FactoryGirl.build(:user, email: @user_one.email.upcase)).to_not be_valid
    end
  end

  describe "passwords" do
    it "has a password attribute" do
      expect(@user).to respond_to(:password)
    end

    it "has a password confirmation attribute" do
      expect(@user).to respond_to(:password_confirmation)
    end

    context "validations" do
      before(:each) do
        @email = Faker::Internet.safe_email
      end

      it "requires a password" do
        expect(FactoryGirl.build(:user, password: "", password_confirmation: "")).to_not be_valid
        expect(FactoryGirl.build(:user, password: nil, password_confirmation: nil)).to_not be_valid
      end

      it "requires a matching password confirmation" do
        expect(FactoryGirl.build(:user, password: "testtest", password_confirmation: nil)).to_not be_valid
        expect(FactoryGirl.build(:user, password: "testtest", password_confirmation: "not-the-password")).to_not be_valid
      end

      it "rejects short #{Devise.password_length.min}" do
        pass = "a" * (Devise.password_length.min - 1)
        expect(FactoryGirl.build(:user, password: pass, password_confirmation: pass)).to_not be_valid
      end

      it "accepts short passwords" do
        pass = "a" * Devise.password_length.min
        expect(FactoryGirl.build(:user, password: pass, password_confirmation: pass)).to be_valid
      end

      it "accepts long passwords" do
        pass = "a" * Devise.password_length.max
        expect(FactoryGirl.build(:user, password: pass, password_confirmation: pass)).to be_valid
      end

      it "reject passwords longer than #{Devise.password_length.max}" do
        pass = "a" * (Devise.password_length.max + 1)
        expect(FactoryGirl.build(:user, password: pass, password_confirmation: pass)).to_not be_valid
      end
    end

    context "encryption" do
      it "has an encrypted password attribute" do
        expect(@user).to respond_to(:encrypted_password)
      end

      it "sets the encrypted password attribute" do
        expect(@user.encrypted_password).to_not be_blank
      end
    end
  end

  describe "display name" do
    it "has a display name" do
        expect(@user).to respond_to(:display_name)
    end

    it "displays email if name missing" do
      user = FactoryGirl.build(:user)
      expect(user.display_name).to be(user.email)
    end

    it "displays name if name present" do
      user = FactoryGirl.create(:user, name: name = Faker::Name.name)
      expect(user.display_name).to be(user.name)
    end
  end

  describe "avatar" do
    it "has an avatar_url" do
      expect(@user).to respond_to(:avatar_url)
    end

    it "uses the value from the database if one exists" do
      avatar_url = Faker::Internet.url
      user = FactoryGirl.build(:user, avatar_url: avatar_url)
      expect(user.avatar_url).to eq(avatar_url)
    end

    it "uses the first authentication method found, if one exists"

    it "uses Gravatar, as a last resort" do
      expect(FactoryGirl.build(:user).avatar_url).to match /gravatar.com/i
    end
  end

  describe "first name" do
    it "has a first name" do
      expect(@user).to respond_to(:first_name)
    end

    it "first name should be first part of name" do
      user = FactoryGirl.create(:user, name: name = Faker::Name.name)
      expect(user.first_name).to eq(user.name.split(' ').first)
    end
  end
end
