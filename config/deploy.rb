# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mathapp'
set :application_hostname, 'linode.example.com'
set :user, 'deployer' # Deployment user on remote servers
set :local_user, ENV['USER'] || ENV['USERNAME']  # Local user account, on dektop/laptop
set :use_sudo, false

def vhost_name
  fetch(:application_virtual_hostname) || fetch(:application_server_hostname)
end

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name' # Set per-env
set :deploy_via, :remote_cache

# Default value for :scm is :git
set :scm, :git
set :repo_url, 'git@github.com:K-and-R/mathapp.git'

# Get branch to deploy
def branch_name(default_branch)
  branch = ENV["REVISION"] || ENV["BRANCH"] || ENV["TAG"] || default_branch
  if branch == '.'
    # current branch
    `git rev-parse --abbrev-ref HEAD`.chomp
  else
    branch
  end
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, branch_name('master')
set :git_remote, ENV['GIT_REMOTE'] || 'origin'

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, ENV['LOG_LEVEL'] || :debug

def with_verbosity(verbosity_level)
  old_verbosity = SSHKit.config.output_verbosity
  begin
    SSHKit.config.output_verbosity = verbosity_level
    yield
  ensure
    SSHKit.config.output_verbosity = old_verbosity
  end
end

# Default value for :pty is false
set :pty, false

# Default value for :linked_files is []
set :linked_files, %w{.rbenv-vars}

# Default value for linked_dirs is []
set :linked_dirs, %w{
  data
  log
  public/system
  run
  tmp/cache
  tmp/pids
  tmp/sockets
  tmp/video
  vendor/bundle
}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

####
# Rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_roles, :all
set :rbenv_custom_path, "/home/#{fetch(:user)}/.rbenv"

####
# Bundler
set :bundle_flags, '--deployment'
set :bundle_roles, :all
set :bundle_without, %w{development tests}.join(' ')

####
# Sidekiq
set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
set :sidekiq_pid, "#{shared_path}/run/sidekiq.pid"

####
# Apache config
set :apache_root, "/etc/apache2"
set :apache_vhosts_dir, "#{fetch(:apache_root)}/sites-available"

# ####
# # Phusion Passenger (mod_passenger) config
# set :passenger_restart_with_sudo, true
# set :passenger_restart_command, 'apache2ctl graceful'
# set :passenger_restart_with_touch, true

namespace :deploy do
  # Deploy Flow
  # deploy:starting    - start a deployment, make sure everything is ready
  # deploy:started     - started hook (for custom tasks)
  # deploy:updating    - update server(s) with a new release
  # deploy:updated     - updated hook
  # deploy:publishing  - publish the new release
  # deploy:published   - published hook
  # deploy:finishing   - finish the deployment, clean up everything
  # deploy:finished    - finished hook

  # Full deploy flow
  # deploy
  #   deploy:starting
  #     [before]
  #       deploy:ensure_stage
  #       deploy:set_shared_assets
  #     deploy:check
  #   deploy:started
  #   deploy:updating
  #     git:create_release
  #     deploy:symlink:shared
  #   deploy:updated
  #     [before]
  #       deploy:bundle
  #     [after]
  #       deploy:migrate
  #       deploy:compile_assets
  #       deploy:normalize_assets
  #   deploy:publishing
  #     deploy:symlink:release
  #   deploy:published
  #   deploy:finishing
  #     deploy:cleanup
  #   deploy:finished
  #     deploy:log_revision


  desc "Initial server configuration setup"
  task :setup_config do
    on roles([:web, :app]) do
      ## Apache  Setup / Config
      sudo "rm #{fetch(:apache_vhosts_dir)}/#{vhost_name}.conf;" unless test("[ ! -e #{fetch(:apache_vhosts_dir)}/#{vhost_name}.conf ]") || test("[ `readlink #{fetch(:apache_vhosts_dir)}/#{vhost_name}.conf` eq '#{current_path}/config/apache2.conf' ]")
      sudo "ln -nfs #{current_path}/config/apache2.conf #{fetch(:apache_vhosts_dir)}/#{vhost_name}.conf;" unless test("[ -e #{fetch(:apache_vhosts_dir)}/#{vhost_name}.conf ]")
    end
  end
  before :starting, "deploy:setup_config"

  desc "Check that local git repo is in sync with remote"
  task :check_revision do
    on roles([:web, :app]) do
      unless `git rev-parse HEAD` == `git rev-parse #{fetch(:git_remote)}/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as #{fetch(:git_remote)}/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end
  before :updating, "deploy:check_revision"

  desc "Restarting Sidekiq"
  task :restart_sidekiq do
    on roles([:web, :app]) do
      sudo "#{current_path}/script/killall_sidekiq"
    end
  end
  after :publishing, :restart_sidekiq

  %w{start stop}.each do |command|
    desc "#{command.capitalize}ing Apache web server"
    task "#{command}_apache" do
      on roles(:app) do
        sudo "apache2ctl #{command}"
      end
    end
  end

  desc 'Restarting Apache web server'
  task :restart_apache do
    on roles(:web) do
      sudo 'apache2ctl graceful'
    end
  end
  after :publishing, :restart_apache

  desc 'Enable site'
  task :enable_site do
    on roles(:web) do
      sudo "a2ensite #{vhost_name}" unless test("[ -e /etc/apache2/sites-enabled/#{vhost_name}.conf ]")
    end
  end
  before :restart_apache, 'deploy:enable_site'

  desc 'Check that app is responding'
  task :ping do
    on roles(:web) do
      execute :curl, ' --silent',  fetch(:ping_url)
    end
  end
  after :restart_apache, 'deploy:ping'

  task :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'tmp:cache:clear'
      end
    end
  end
  after :restart_apache, :clear_cache
end
