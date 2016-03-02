shared_context 'login' do
  def log_in_with_user(user, options={})
    email = options[:email] || user.email
    password = options[:password] || user.password
    # Do login with new, valid user account
    visit new_user_session_path
    fill_in "user_email", with: email
    fill_in "user_password", with: password, exact: true
    click_button "Log In"
  end
end
