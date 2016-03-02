shared_context 'registration' do
  def register_and_confirm_user(user, options = {})
    register_user(user, options)
    confirm_user(user, options)
  end

  def register_user(user, options = {})
    email = options[:email] || user.email
    password = options[:password] || user.password
    password_confirmation = options[:password_confirmation] || user.password_confirmation
    # Do user registration
    visit new_user_registration_path
    fill_in "user_email", with: email
    fill_in "user_password", with: password, exact: true
    fill_in "user_password_confirmation", with: password_confirmation
    click_button "Create Account"
  end

  def confirm_user(user, options = {})
    open_email(@user.email)
    current_email.click_link 'Confirm my account'
  end
end
