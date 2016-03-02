require 'spec_helper'

describe "Login" do
  include_context 'login'
  include_context 'registration'

  before do
    @user = FactoryGirl.build(:user)
  end

  it "loads (HTTP 200)" do
    get new_user_session_path
    expect(response.status).to be(200)
  end

  it "is accessable from Log In link" do
    visit root_path
    click_link "Log In"
    expect(current_path).to eq(login_path)
  end

  it "fails if provided bad email" do
    log_in_with_user @user, {email: 'user@bademail.wrong'}
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("Invalid email or password.")
  end

  it "fails if provided bad password" do
    log_in_with_user @user, {password: 'this-is-not-the-password'}
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("Invalid email or password.")
  end

  it "redirects to dashboard_path after registration" do
    register_user @user
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("You have signed up successfully.")
  end

  it "redirects to dashboard_path after email confirmation" do
    register_and_confirm_user @user
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Your email address has been successfully confirmed.")
  end

  it "redirects to dashboard_path after valid login" do
    user = FactoryGirl.create(:user)
    log_in_with_user user
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Signed in successfully.")
  end

  it "redirects to admin_dashboard_path after valid admin login" do
    admin = FactoryGirl.create(:admin_user)
    log_in_with_user admin
    expect(current_path).to eq(admin_dashboard_path)
    expect(page).to have_content("Signed in successfully.")
  end
end
