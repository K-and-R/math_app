# VPS Environment Setup

We use exclusively Ubuntu 14.04 for our production environments.

## Base Configuration
Start by following the [Ubuntu Setup instructions](./Ubuntu-Setup.md).

### Apache

Install Apache by following the [Apache Installation instructions](./Apache-Installation.md).

### Development Database

#### MySQL

This section may be skipped if MySQL will not be the project's development database.

Install MySQL by following the [MySQL Installation instructions](MySQL-Installation.md).

#### PostgreSQL

Install PostgreSQL by following the [PostgreSQL Installation instructions](./PostgreSQL-Installation.md).

Create the production database:
```bash
sudo -u postgres createuser mathapp --createdb --login --no-superuser --no-createrole --pwprompt
sudo -u postgres createdb -O mathapp mathapp 
```
Ensure that the password is set in the `DATABASE_URL` stored in the applications environment variables file (detailed in the "Rbenv" section below). It should look something like this:
```bash
DATABASE_URL=postgres://db_user:db_password@db_host:db_port/db_name
```

### NodeJS

Install NodeJS by following the [NodeJS Installation instructions](./NodeJS-Installation.md).

After NodeJS is done installing, install NPM.

Install NPM by following the [NPM Installation instructions](./NPM-Installation.md).

### Redis

Install Redis by following the [Redis Installation instructions](./Redis-Installation.md).

#### Services
##### Sidekiq
We use this. Sidekiq requires Redis.

From https://github.com/mperham/sidekiq/wiki:

> Sidekiq is a full-featured background processing framework for Ruby. It aims to be simple to integrate with any modern Rails application and much higher performance than other existing solutions.

For more information on Sidekiq, go to [http://sidekiq.org/](http://sidekiq.org/).

For information on adding Sidekiq to an application, go to [http://railscasts.com/episodes/366-sidekiq?view=asciicast](http://railscasts.com/episodes/366-sidekiq?view=asciicast).

### PhantomJS

Install PhantomJS by following the [PhantomJS Installation instructions](./PhantomJS-Installation.md).

### ImageMagick

Install ImageMagick by Following the [ImageMagick Installation instructions](./ImageMagick-Installation.md).

## Deployment via Capistrano

### Capistrano

From http://capistranorb.com/documentation/overview/what-is-capistrano/:

> Capistrano is a remote server automation tool.
It supports the scripting and execution of arbitrary tasks, and includes a set of sane-default deployment workflows.

#### Server Configuration

Edit the [deployment configuration for the production environment](../config/deploy/production.rb) to use the proper values for `application_virtual_hostname` and `application_server_hostname` (replace "`mathapp.example.com`" with the proper hostname), and for `ping_url` (replace the example URL with the proper URL for your hosted application).

Edit the [gloabl deployment configuration file](../config/deploy.rb) to use the proper value for `git_url` (replace the example URL with the proper URL for your Git repo).

Edit the [apache vhost configuration file](../config/apache2.conf) to use the proper value for your Apache configuration.

The deployer user needs to be added to the servers. This will be the user account that owns and updates the code on the server.

**Creating the deployer user**
```bash
sudo groupadd deployer
sudo useradd -c "Deployment User Account" -m -g deployer -Gusers,www-data -s/bin/bash deployer
sudo mkdir -p /home/deployer/.ssh 
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwwjAIXd5Ha7+irmTsTjp6LBZfH0Z+Z9pYEgy8NmqKNbMcpS1FQYsaiaHJsGpGfmiCtK3jT0W+rBjNLtQ/fL66rceb8yYXvxw0DAyWHiFROkqTEMO6olIo7ML9W2wrQxjKvOVpUdWYiXUEDohgIFyUjlaCbhGxjJlFDtSSCxt3eLH/vc6zEl/HfZTHxa5CbGAqF8hhe13auqlfiElNgenyYLetIywbMxT5N7KBSjb/w/jRlavl3RZAtCMBzvan1cH46U7t8JmCXgzwgvuXGJ6d4JWzW57CHGTz0VliKyKGOdtltys73TQW83qj8HT1gXVmC/k+yIaRgdLa4GhookpT deployer@perceivers.net" | sudo tee /home/deployer/.ssh/authorized_keys > /dev/null
echo "|1|sNmIQVbI6NWqZjnkOcxeD/ufGT0=|jq7g/YsIj3k9JRf5Rg/Hvt/xGKQ= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|kLfbUBZaVD5WqGfgwfAQBsek8Jk=|EIbKAMcgsJnTNElCDq8SSF+pT2I= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|Ctno1XtTCkNgDrHameCo029uoVo=|LXpcUgs+inL8m5WgTSYRyH0tM4A= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr5LKYtDEUyt54X6nHoLUJ/6+wcOYlK03F7gwOfptmvjMwROD6CgI89iAv3pbvzkZTwdA13JqaKuOWDpSxbK/7miLwkNpr/udSqrjwSwynf8nd/ijqK9PnOW5tvtSmNkYhZx7oLX1ofRc22XSxyQlQJmwitNb2LAykpwTBJkOnBoTzWMS8yYweA6p8TUBZbKXtrXFh2O93H23oz6lV4fWxS3kzD1jcW3zkD08eXRbpKFACDZNmWkIY4UyeT1bo0CkShZZCIx0MHSrS0JmAjz3TUqhw72gYR9+4uBFXt1tPPaotCzxAraJy2x4aFvG6JEzcPSXoD0spitlUEKOjhkbww==
|1|UV9W/Ys2vATqoeAFoIpCpoEZrC0=|ySUbhiBBq4NbxsQdUGpaWwef8lo= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr5LKYtDEUyt54X6nHoLUJ/6+wcOYlK03F7gwOfptmvjMwROD6CgI89iAv3pbvzkZTwdA13JqaKuOWDpSxbK/7miLwkNpr/udSqrjwSwynf8nd/ijqK9PnOW5tvtSmNkYhZx7oLX1ofRc22XSxyQlQJmwitNb2LAykpwTBJkOnBoTzWMS8yYweA6p8TUBZbKXtrXFh2O93H23oz6lV4fWxS3kzD1jcW3zkD08eXRbpKFACDZNmWkIY4UyeT1bo0CkShZZCIx0MHSrS0JmAjz3TUqhw72gYR9+4uBFXt1tPPaotCzxAraJy2x4aFvG6JEzcPSXoD0spitlUEKOjhkbww==
" | sudo tee /home/deployer/.ssh/known_hosts > /dev/null
sudo chown -R deployer:deployer /home/deployer
sudo sed -i 's@^deployer:.*$@deployer:$6$EfLo.0CQ$/iNVKASrXVwcnKdMl/wKe8Rmv7.F74aE/hVnBZLXMm0LqI8OYTzk8l2oQGfkYUGtq193OZ8LyOGw57C48XeS9.:16141:0:99999:7:::@' /etc/shadow
sudo usermod -aG sudo,admin deployer
echo "deployer ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/deployer > /dev/null
```

##### Add access for deployer users
Example:
```bash
cat /home/karl/.ssh/authorized_keys | sudo tee -a /home/deployer/.ssh/authorized_keys > /dev/null
```

## Additional Configuration

### Rbenv

For this part of the setup, one needs to be connected to the server as deployer.

Install Rbenv by following the [Rbenv Installation instructions](./Rbenv-Installation.md).

You will create the `.rbenv-vars` to store any environment variables for your production application:
```bash
sudo tee /srv/http/mathapp.example.com/shared/.rbenv-vars > /dev/null <<'EOF'
DATABASE_URL=postgres://db_user:db_password@db_host:db_port/db_name
RACK_ENV=production
RAILS_ENV=production
EOF
```
