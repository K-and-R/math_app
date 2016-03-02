pid "tmp/pids/unicorn.pid"
stdout_path "log/unicorn.log"
stderr_path "log/unicorn-err.log"

worker_processes 3
timeout 30
preload_app true

require 'fileutils'
FileUtils.mkdir_p 'tmp/pids/' unless File.exist? 'tmp/pids/'
FileUtils.mkdir_p 'log/' unless File.exist? 'log/'

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end
 
  sleep 1
end
 
after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
end
