require 'spec_helper'

describe "UserRegistration" do

  before do
    @user = build(:user)
  end

  it "loads (HTTP 200)" do
    get new_user_registration_path
    expect(response.status).to be(200)
  end

  it "is accessable from Register link" do
    visit root_path
    click_link "Register"
    expect(current_path).to eq(register_path)
  end

  it "emails user when submitting registration form" do
    visit new_user_registration_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password, exact: true
    fill_in "user_password_confirmation", with: @user.password_confirmation
    click_button "Create Account"
    expect(emails.size).to eq(1)
    expect(last_email.to).to include(@user.email)
  end

  it "redirects to dashboard_path after registration" do
    visit new_user_registration_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password, exact: true
    fill_in "user_password_confirmation", with: @user.password_confirmation
    click_button "Create Account"
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("You have signed up successfully.")
  end
end
