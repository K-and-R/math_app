class PasswordsController < Devise::PasswordsController
  skip_authentication
end
