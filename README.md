Rails Api Bootstrap
================
[![CircleCI](https://circleci.com/gh/widergy/rails-api-bootstrap.svg?style=shield&circle-token=964bdb144b89940be35965f42454a7476d437d39)](https://circleci.com/gh/widergy/rails-api-bootstrap)

Kickoff for Rails API applications.

## API Documentation

[replace]

## Running local server

### 1- Installing Ruby

- Clone the repository by running `git clone https://github.com/widergy/rails-api-bootstrap.git`
- Go to the project root by running `cd rails-api-bootstrap`
- Download and install [Rbenv](https://github.com/rbenv/rbenv#basic-github-checkout).
- Download and install [Ruby-Build](https://github.com/rbenv/ruby-build#installing-as-an-rbenv-plugin-recommended).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version). If the version you are looking cannot be found, [be sure to have Ruby-Build updated](https://github.com/rbenv/ruby-build#upgrading)

### 2- Installing Rails gems

- Install [Bundler](http://bundler.io/).

```bash
  gem install bundler --no-ri --no-rdoc
  rbenv rehash
```
- Install basic dependencies:

  - If you are using Ubuntu:

  ```bash
    sudo apt-get install build-essential libpq-dev nodejs
  ```

  - If you are using MacOS:

  ```bash
    brew install postgresql
  ```

- Install all the gems included in the project.

```bash
  bundle -j 20
```

### 3- Database Setup

- Install postgres in your local machine:

  - If you are using Ubuntu:

  ```bash
    sudo apt-get install postgresql-9.6
  ```

  - If you are using MacOS: install [Postgres.app](https://postgresapp.com/)

- Create the development database:

  - If you are using Ubuntu:

    Run in terminal:

    ```bash
      sudo -u postgres psql
      CREATE ROLE "rails-api-bootstrap" LOGIN CREATEDB PASSWORD 'rails-api-bootstrap';
    ```

  - If you are using MacOS:

    Open the Postgres app and run in that terminal:

    ```bash
      CREATE ROLE "rails-api-bootstrap" LOGIN CREATEDB PASSWORD 'rails-api-bootstrap';
    ```

- Log out from postgres

- Check if you have to get a `.env` file, and if you have to, copy it to the root.

- Run in terminal:

```bash
  bundle exec rake db:create db:migrate
```

### 4- Application Setup

- Run ./script/bootstrap app_name where app_name is your application name.

Your server is ready to run. You can do this by executing `bundle exec rails server` inside the project's directory and going to [http://localhost:3000](http://localhost:3000).

Your app is ready. Happy coding!

PS: If you don't want to have to use `bundle exec` for rails commands, then run in terminal:

```bash
  sudo gem install rails
```

If you want to access to the rails console you can just execute `rails console` inside the project's directory. Alternatively you can use the `pry` gem instead. First you need to install it:

```bash
  gem install pry pry-doc
```

And then execute `pry -r ./config/environment` instead of `rails console`.

#### Running tests & linters

- For running the test suite:

  - The first time assure to have redis up. Run in terminal:

  ```bash
    redis-server
  ```

  - Run in terminal:

  ```bash
    bundle exec rspec
  ```

- For running code style analyzer:

```bash
  bundle exec rubocop app spec -R
```

#### Git pre push hook

You can modify the [pre-push.sh](script/pre-push.sh) script to run different scripts before you `git push` (e.g Rspec, Linters). Then you need to run the following:

```bash
  chmod +x script/pre-push.sh
  sudo ln -s ../../script/pre-push.sh .git/hooks/pre-push
```

You can skip the hook by adding `--no-verify` to your `git push`.

## Running with Docker

Read more [here](docs/docker.md)

## Deploy Guide

Read more [here](docs/deploy.md)

## Rollbar Configuration

`Rollbar` is used for exception errors report. To complete this configuration setup the following environment variables in your server
- `ROLLBAR_ACCESS_TOKEN`

with the credentials located in the rollbar application.

If you have several servers with the same environment name you may want to difference them in Rollbar. For this set the `ROLLBAR_ENVIRONMENT` environment variable with your environment name.

## Health Check

Health check is a gem which enables an endpoint to check the status of the instance where this is running. It is configured for checking sidekiq, redis status, migrations and the database among others checks. The checks can be customized inside the [configuration file](/config/initializers/health_check.rb).

## Brakeman

To run the static analyzer for security vulnerabilities run:

```bash
  bundle exec brakeman -z -i config/brakeman.ignore
```

## Dotenv

We use [dotenv](https://github.com/bkeepers/dotenv) to set up our environment variables in combination with `secrets.yml`.

For example, you could have the following `secrets.yml`:

```yml
production: &production
  foo: <%= ENV['FOO'] %>
  bar: <%= ENV['BAR'] %>
```

and a `.env` file in the project root that looks like this:

```
FOO=1
BAR=2
```

When the application loads up, `Rails.application.secrets.foo` will equal `ENV['FOO']`, making the environment variables reachable across the Rails app. The `.env` will be ignored by `git` so it won't be pushed into the repository, thus keeping tokens and passwords safe.

## PGHero Authentication

Set the following variables in your server.

```bash
  PGHERO_USERNAME=username
  PGHERO_PASSWORD=password
```

And you can access the PGHero information by entering `/pghero`.

<!-- ## Debugging Chrome Console

It is a simple and useful way to look at Rails logs without having to look at the console, it also show queries executed and response times.
Install the [Rails Panel Extension](https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg). This is recommended way of installing extension, since it will auto-update on every new version. Note that you still need to update meta_request gem yourself.

![railspanel](https://cloud.githubusercontent.com/assets/4494/3090049/917e5378-e586-11e3-9bd4-1db232968126.png) -->

## Documentation

You can find more documentation in the [docs](docs) folder. The available docs are:

- [Run locally with Docker](docs/docker.md)
- [Deploy guide](docs/deploy.md)
- [Locales structure](docs/locales.md)
- [Seeds](docs/seeds.md)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rspec tests (`bundle exec rspec spec -fd`)
5. Run rubocop lint (`bundle exec rubocop app spec -R`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request

## About

This project is written by [Widergy](http://www.widergy.com).

![Widergy](https://image.ibb.co/b7L3ZG/logo_slogan1_color.png)
