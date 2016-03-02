# Development Environment Setup

We use exclusively Ubuntu 14.04 for our development environment.

## Base Configuration
Start by following the [Ubuntu Setup instructions](./Ubuntu-Setup.md).

## Additional Configuration

### Sublime Text

From http://www.sublimetext.com/:

> Sublime Text is a sophisticated text editor for code, markup and prose. You'll love the slick user interface, extraordinary features and amazing performance.

#### Installation

**Sublime Text 3**

Visit [http://www.sublimetext.com/3](http://www.sublimetext.com/3) and download the appropriate package to your ```~/packages/``` directory; install it using gdebi; then to symlink sublime to the subl command with the following:
```bash
cd  ~/packages/ && \
wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb && \
sudo gdebi ~/packages/sublime-text_build-*.deb && \
sudo ln -s `which subl` $(dirname `which subl`)/sublime;
```

**Sublime URL Handler**
Create the Sublime URL Parser file '/usr/local/bin/subl-url-parser':
```bash
sudo tee /usr/local/bin/subl-url-parser > /dev/null <<"EOF"
#!/usr/bin/env bash
 
request=${1:23}               # Delete the first 23 characters "subl://open?url=file://"
request=${request//%2F//}     # Replace %2F with /
request=${request/&line=/:}   # Replace &line= with :
request=${request/&column=/:} # Replace &column= with :
sublime $request              # Launch Sublime
EOF
```
Make it executable, and symlink it to "subl-url-handler":
```bash
sudo chmod +x /usr/local/bin/subl-url-parser
sudo ln -s subl-url-parser /usr/local/bin/subl-url-handler
```
Create (or update) the desktop file ' /usr/share/applications/sublime-handler.desktop' to use your new URL parser via 'subl-url-handler':
```bash
sudo tee /usr/share/applications/sublime-handler.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Sublime Text URL Handler
GenericName=Text Editor
Comment=Handle URL Scheme subl://
Exec=subl-url-handler %u
Terminal=false
Type=Application
MimeType=x-scheme-handler/subl;
Icon=sublime-text
Categories=TextEditor;Development;Utility;
Name[en_US]=Sublime Text URL Handler
EOF
```
Update the database:
```bash
sudo update-desktop-database
```

**Package Control**
Open Sublime Text 3.
Go to [https://packagecontrol.io/installation](https://packagecontrol.io/installation) and follow the instructions for "Sublime Text 3".

### Rbenv

Install Rbenv by following the [Rbenv Installation instructions](./Rbenv-Installation.md).

### Development Database

#### MySQL

This section may be skipped if MySQL will not be the project's development database.

Install MySQL by following the [MySQL Installation instructions](./MySQL-Installation.md).

#### PostgreSQL

Install PostgreSQL by following the [PostgreSQL Installation instructions](./PostgreSQL-Installation.md).

Use the script at `bin/create-pg-app-db` once for each database you need to make. IE:
```
bin/create-pg-app-db mathapp_dev
```
and
```
bin/create-pg-app-db mathapp_test
```
Use the database name (eg: 'mathapp_development') for the password.

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

### Database Initialization
Run:
```
bundle exec rake db:migrate;
bundle exec rake db:seed;
```

### Fake Development Data
Start your Rails console (`rails c`) and run:
```bash
require 'factory_girl_rails'
I18n.reload!
Dir.glob('spec/factories/*.rb'){|file| FactoryGirl.load(file)}
FactoryGirl.create_list(:user, 10)
```

### Setup of Testing Environment
Create the testing database:
```bash
bin/create-pg-app-db mathapp_test
```

Update the database:
```bash
RAILS_ENV=test rake db:migrate; RAILS_ENV=test rake db:seed;
```

### Running Tests
```bash
bundle exec rspec
```
...grab some coffee.

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

### GitHub SSH Key

From https://help.github.com/articles/generating-ssh-keys/:

> SSH keys are a way to identify trusted computers, without involving passwords.

Go to [https://help.github.com/articles/generating-ssh-keys/](https://help.github.com/articles/generating-ssh-keys/) and follow the instructions on that page.
