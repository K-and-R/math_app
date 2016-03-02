Rails.application.configure do
  config.logger = Logger.new(STDOUT)

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
end
