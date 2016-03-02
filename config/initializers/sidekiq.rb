require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [Rails.configuration.sidekiq.web.username, Rails.configuration.sidekiq.web.password]
end

redis_url = Rails.configuration.sidekiq.redis.url
redis_url ||= Rails.configuration.redis.url

Rails.logger.warn 'MISSING SIDEKIQ REDIS URL' unless redis_url.present?

Sidekiq.configure_server do |config|
  config.redis = {
    url: redis_url,
    namespace:  "#{Rails.application.name} #{Rails.env} sidekiq".slugify
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: redis_url,
    namespace:  "#{Rails.application.name} #{Rails.env} sidekiq".slugify
  }
end

module Sidekiq
  def self.reset_counters
    reset_processed_counter
    reset_failed_counter
  end

  def self.reset_processed_counter
    redis {|c| c.del('stat:processed') }
  end

  def self.reset_failed_counter
    redis {|c| c.del('stat:failed') }
  end

  def self.clear_queue
    Sidekiq::Queue.new.clear
  end

  def self.flush_and_reset
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
    clear_queue
    reset_counters
  end
end
