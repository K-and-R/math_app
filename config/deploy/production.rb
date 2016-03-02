set :stage, :production
set :application, 'mathapp'
set :application_server_hostname, 'linode.example.com'
set :application_virtual_hostname, 'app.example.com'
set :log_level, :info

# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.
role :app, %w{deployer@linode.example.com}
role :web, %w{deployer@linode.example.com}
role :db,  %w{deployer@linode.example.com}

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
set :deploy_to, "/srv/http/#{fetch(:application_virtual_hostname)}"
set :ping_url, "http://#{fetch(:application_virtual_hostname)}/ping"

set :ssh_options, {
  user: fetch(:user),
  # keys: %w(/home/deployer/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey)
}

# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

namespace :deploy do
  desc "Confirm deployment to production environment"
  task :confirm_production_deployment do
    warn <<-WARN

    ========================================================================

    WARNING: You're about to perform actions on production server(s)
    Please confirm that all your intentions are kind and friendly

    ========================================================================

    WARN
    ask(:deployment_confirmation, " You you sure you want to continue? (y/N) ")
    on roles(:all) do |h|
      if fetch(:deployment_confirmation).to_s.upcase[0] != 'Y'
        puts "\nDeployment cancelled!\n".red
        exit
      end
    end
  end

  unless ENV["SKIP_DEPLOYMENT_CONFIRMATION"]
    before :starting, :confirm_production_deployment
  end
end
