class UserMailer < ActionMailer::Base
  default from: Rails.configuration.email.defaults.sender_address

  def invitation(user, url_token)
    @user = user
    @url_token = url_token
    mail(to: "#{@user.name} <#{@user.email}>", subject: 'Invitation')
  end
end
