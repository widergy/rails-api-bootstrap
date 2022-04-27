source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
gem 'puma', '~> 5.6'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Authentication
gem 'devise', '~> 4.7'
gem 'devise-i18n'

# Centralization of locale data collection for Ruby on Rails.
gem 'rails-i18n', '~> 6.0'

# Active Admin provides an instant CMS backend.
gem 'activeadmin', '~> 2.3'
# gem 'activeadmin_addons'

# Use for sending request to 3rd party APIs
gem 'httparty', '~> 0.17'

# For PORO management
gem 'interactor', '~> 3.0'

# A serializer implementation for Ruby On Rails Objects.
gem 'active_model_serializers', '~> 0.10.9'

# Sidekiq
gem 'sidekiq', '<7'
gem 'sidekiq-failures'
# gem 'sidekiq_mailer'
# gem 'sidekiq-scheduler', '~> 3.0'

# Exceptions Report
gem 'rollbar'

# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem 'jwt'

# Use Rack CORS for handling Cross-Origin Resource Sharing, making cross-origin AJAX possible
gem 'rack-cors', '>= 1.0.4', require: 'rack/cors'

# Use for DoS attacks
gem 'rack-attack', '~> 6'

# Simple health check of Rails app for use with uptime checking sites
gem 'health_check', '3.0'

# Use for generate a Entity-Relationship diagram based on the application's Active Record models
gem 'rails-erd'

# If string, numeric, symbol and nil values wanna be a boolean value, they can with the new to_b
# method.
gem 'wannabe_bool'

# Gem to detect N+1 queries
gem 'bullet'

# (alternative to active_model_serializers) A lightning fast JSON:API serializer for Ruby Objects.
# gem 'fast_jsonapi', '~> 1.5'

# pg_search builds ActiveRecord named scopes that take advantage of PostgreSQL's full text search
# gem 'pg_search'

# New Relic agent
# gem 'newrelic_rpm'

# A smart profiler for Ruby on Rails applications. It turns performance data into actionable
# insights
# gem 'skylight'

# Rescue and report exceptions in non-critical code
# gem 'safely_block'

# A plugin for versioning Rails based RESTful APIs.
gem 'versionist'

# For handling requests that relies in 3rd party API calls
# gem 'async_request', github: 'icapuccio/async-requests', branch: 'version-0-9'

# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for modern
# web app frameworks and ORMs
gem 'kaminari'

# Role management library with resource scoping
# gem 'rolify'

# Authorization Policies
# gem 'pundit'

# Never accidentally send emails to real people from your staging environment.
# gem 'recipient_interceptor'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use for caching data
# gem 'redis-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'carrierwave'
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Ruby cloud services library
# gem 'fog'

# Use for accessing AWS buckets
# gem 'aws-sdk-rails'

# Gives every ActiveRecord::Base object the possibility to do a deep clone that includes user
# specified associations
# gem 'deep_cloneable', '~> 2.4.0'

# Postgres insights
gem 'pghero'

group :test do
  # Rspec helpers
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'

  # Code coverage
  gem 'simplecov', require: false

  # Mocking
  gem 'webmock'
  gem 'timecop', '~> 0.9'
  gem 'vcr'

  # Tests performance
  gem 'test-prof'

end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Adds step-by-step debugging and stack navigation capabilities to pry using byebug.
  gem 'pry-byebug'

  # RSpec testing framework for Ruby on Rails as a drop-in alternative to its default testing
  # framework, Minitest.
  gem 'rspec-rails', '~> 5.0'

  # Awesome Print is a Ruby library that pretty prints Ruby objects in full color exposing their
  # internal structure with proper indentation
  gem 'awesome_print'

  # Factories
  gem 'factory_bot_rails'
  gem 'faker'

  # Use for storing credentials and not uploading them to github. Loads ENV variables from .env
  # file in base folder
  gem 'dotenv-rails'

  # Code style
  gem 'rubocop', '0.89', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', '~> 1.32.0', require: false

  # Static analysis for security vulnerabilities
  gem 'brakeman', require: false

  # Code quality
  # gem 'codestats-metrics-reporter', '0.1.9', require: false
  gem 'rails_best_practices', require: false
  gem 'rubycritic', require: false

  # Speedup Test::Unit + RSpec + Cucumber + Spinach by running parallel on multiple CPU cores.
  # gem 'parallel_tests'
end

group :development do
  # The Listen gem listens to file modifications and notifies you about the changes.
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Better Errors replaces the standard Rails error page with a much better and more useful
  # error page.
  gem 'better_errors'

  # Add a comment summarizing the current schema to the top or bottom of each of your models
  gem 'annotate'

  # Required gem to use RailsPanel Chrome extension
  # gem 'meta_request'

  # Preview email in the default browser instead of sending it
  # gem 'letter_opener'
end
