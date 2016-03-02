class ConfirmationsController < Devise::ConfirmationsController
  skip_authentication
end
