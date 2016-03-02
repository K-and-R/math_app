require 'spec_helper'

describe "PasswordReset" do
  include_context 'login'
  include_context 'registration'

  before do
    @user = build(:user)
  end

  it "loads (HTTP 200)" do
    get new_user_password_path
    expect(response.status).to be(200)
  end

  it "is accessable from Forgot Password link" do
    visit new_user_session_path
    expect(current_path).to eq(new_user_session_path)

    click_link "Forgot Password?"
    expect(current_path).to eq(new_user_password_path)
  end

  it "gives error for unknown email" do
    visit new_user_password_path
    expect(current_path).to eq(new_user_password_path)

    fill_in "Email", with: 'not-a-user@example.wrong'
    click_button "Send me reset password instructions"
    expect(emails.size).to eq(0)
    expect(current_path).to eq(user_password_path)
    expect(page).to have_content("Please review the problems below:")
  end

  it "emails user when requesting password reset" do
    # Register a new account
    register_and_confirm_user @user
    visit destroy_user_session_path

    # Request password reset with valid email
    visit new_user_password_path
    expect(current_path).to eq(new_user_password_path)

    fill_in "Email", with: @user.email
    click_button "Send me reset password instructions"
    expect(emails.size).to eq(2)
    expect(last_email.to).to include(@user.email)
    open_email(@user.email)
    expect(current_email).to have_content('Change my password')
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("You will receive an email")
  end

  it "allows user to login in with new password" do
    # Register a new account
    register_and_confirm_user @user
    visit destroy_user_session_path

    # Request password reset with valid email
    visit new_user_password_path
    expect(current_path).to eq(new_user_password_path)

    fill_in "Email", with: @user.email
    click_button "Send me reset password instructions"
    expect(emails.size).to eq(2)
    expect(last_email.to).to include(@user.email)
    open_email(@user.email)
    current_email.click_link('Change my password')
    expect(current_path).to eq(edit_user_password_path)

    @user.password = 'my_shiny_new-pa55w05d!'

    fill_in "user_password", with: @user.password, exact: true
    fill_in "user_password_confirmation", with: @user.password
    click_button "Change my password"
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Your password has been changed successfully.")
    visit destroy_user_session_path

    log_in_with_user @user
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Signed in successfully.")
  end
end
