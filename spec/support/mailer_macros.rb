module MailerMacros

  def emails
    ActionMailer::Base.deliveries
  end

  def last_email
    emails.last
  end

  def reset_emails
    ActionMailer::Base.deliveries.clear
    clear_emails
  end
end

RSpec.configure do |config|
  # additional factory_girl configuration

  config.before(:each) do
    reset_emails
  end
end