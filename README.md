Math App
===========

This is my math app. There are many like it but this one is mine.

## Tests Passing?
[ ![Codeship Status for K-and-R/MathApp](https://www.codeship.io/projects/dbc28a30-32b0-0132-41a7-26ae991900c0/status)]

## Cloning this Repo

Make a local copy of this Git repo:
```bash
mkdir -p ~/Projects/MathApp
cd ~/Projects/MathApp
git clone git@github.com:K-and-R/mathapp.git
cd mathapp
git checkout develop
```

## Ruby Version

We are presently using Ruby `2.2.2`. This is also defined in the `.ruby-version` file as well as in the Gemfile (as `ruby '2.2.2'`).

For development, Rubys are managed with Rbenv.

## System Dependencies

Depending on how this app is being used, we could require:
* Redis
* MySQL
* PostgreSQL
* Rmagick

## Configuration

```bash
git checkout develop
cp config/settings.local.{example.,}yml
```

## Development Environment Setup

To set up a development environment, follow the [Development Environment Setup instructions](./doc/Development-Setup.md).

## Production Environment Setup

To set up a production environment, follow the [Production Environment Setup instructions](./doc/Production-Setup.md).

## Deployment

### Heroku
We have automatic deployments form GitHub branches set up through Heroku or Codeship. Presently this is on the ```master``` and ```develop``` branches So, we just do:
```bash
git push
```
...then get back to work.

We are running multiple environments on Heroku, those are also configured for automatic deployments. For manual deployment, you might do something like:
```bash
git push staging release-1.2:master
```
or
```bash
git push production master:master
```

Running Tests
-------------
```
bundle exec rspec
```
...grab some coffee.


Deployment
----------

### Capistrano
From your local git repo, in the branch you want to deploy, do:
```bash
cap staging deploy
```
or 
```bash
cap production deploy
```
