source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1', require: false

# Authentication
gem 'devise', '~> 4'
gem 'devise-i18n', '~> 1'

# Elastic APM
gem 'elastic-apm', '~> 4'
gem 'http', '~> 4'

# Centralization of locale data collection for Ruby on Rails.
gem 'rails-i18n', '~> 7'

# Active Admin provides an instant CMS backend.
gem 'activeadmin', '~> 3'
gem 'activeadmin_addons', '~> 1'
gem 'activeadmin_json_editor', '0.0.10'

# Use for sending request to 3rd party APIs
gem 'httparty', '~> 0.21'

# For PORO management
gem 'interactor', '~> 3'

# A serializer implementation for Ruby On Rails Objects.
gem 'active_model_serializers', '~> 0.10'

# Sidekiq
gem 'sidekiq', '~> 7'
gem 'sidekiq-failures', '~> 1'
# gem 'sidekiq_mailer', '~> 0.0.8'
# gem 'sidekiq-scheduler', '~> 5'

# Exceptions Report
gem 'rollbar', '~> 3'

# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem 'jwt', '~> 2'

# Use Rack CORS for handling Cross-Origin Resource Sharing, making cross-origin AJAX possible
gem 'rack-cors', '~> 2', require: 'rack/cors'

# Use for DoS attacks
gem 'rack-attack', '~> 6'

# Simple health check of Rails app for use with uptime checking sites
gem 'health_check', '~> 3'

# If string, numeric, symbol and nil values wanna be a boolean value, they can with the new to_b
# method.
gem 'wannabe_bool', '~> 0.7'

# Gem to detect N+1 queries
gem 'bullet', '~> 7'

# (alternative to active_model_serializers) A lightning fast JSON:API serializer for Ruby Objects.
# gem 'fast_jsonapi', '~> 1.5'

# pg_search builds ActiveRecord named scopes that take advantage of PostgreSQL's full text search
# gem 'pg_search', '~> 2'

# New Relic agent
# gem 'newrelic_rpm', '~> 9'

# A smart profiler for Ruby on Rails applications. It turns performance data into actionable
# insights
# gem 'skylight', '~> 5'

# Rescue and report exceptions in non-critical code
# gem 'safely_block', '~> 0.4'

# A plugin for versioning Rails based RESTful APIs.
gem 'versionist', '~> 2'

# For handling requests that relies in 3rd party API calls
gem 'async_request', git: 'https://github.com/widergy/async-requests.git', branch: 'version-0-10-standarized-logs'

# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for modern
# web app frameworks and ORMs
gem 'kaminari', '~> 1'

# Simple Mail Transfer Protocol client library for Ruby.
# gem 'net-smtp', '~> 0.3'

# Role management library with resource scoping
# gem 'rolify', '~> 6'

# Authorization Policies
# gem 'pundit', '~> 2'

# Never accidentally send emails to real people from your staging environment.
# gem 'recipient_interceptor', '~> 0.3'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5'

# Use for caching data
gem 'redis-rails', '~> 5'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3'

# Use ActiveStorage variant
# gem 'carrierwave', '~> 3'

# Manipulate images with minimal use of memory via ImageMagick / GraphicsMagick
# gem 'mini_magick', '~> 4'

# Ruby cloud services library
# gem 'fog', '~> 2'

# Use for accessing AWS
gem 'aws-sdk-rails', '~> 3'
gem 'aws-sdk-secretsmanager', '~> 1'

# Postgres insights
gem 'pghero', '~> 3'

# Metric monitoring
gem 'prometheus-client'

group :test do
  # Rspec helpers
  gem 'rspec-sidekiq', '~> 4'
  gem 'shoulda-matchers', '~> 5'

  # Code coverage
  gem 'simplecov', '~> 0.22', require: false

  # Mocking
  gem 'timecop', '~> 0.9'
  gem 'vcr', '~> 6'
  gem 'webmock', '~> 3'

  # Tests performance
  gem 'test-prof', '~> 1'
end

group :development, :test do
  # Use Puma as the app server
  gem 'puma', '~> 6.3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11', platforms: %i[mri mingw x64_mingw]

  # Adds step-by-step debugging and stack navigation capabilities to pry using byebug.
  # gem 'pry-byebug', '~> 3'

  # RSpec testing framework for Ruby on Rails as a drop-in alternative to its default testing
  # framework, Minitest.
  gem 'rspec-rails', '~> 6'

  # Awesome Print is a Ruby library that pretty prints Ruby objects in full color exposing their
  # internal structure with proper indentation
  gem 'awesome_print', '~> 1'

  # Factories
  gem 'factory_bot_rails', '~> 6'
  gem 'faker', '~> 3'

  # Use for storing credentials and not uploading them to github. Loads ENV variables from .env
  # file in base folder
  gem 'dotenv-rails', '~> 2'

  # Code style
  gem 'rubocop', '~> 1', require: false
  gem 'rubocop-performance', '~> 1', require: false
  gem 'rubocop-rails', '~> 2', require: false
  gem 'rubocop-rspec', '~> 2', require: false

  # Static analysis for security vulnerabilities
  gem 'brakeman', '~> 6', require: false

  # Code quality
  gem 'rails_best_practices', '~> 1', require: false
  # gem 'rubycritic', '~> 4', require: false

  # Speedup Test::Unit + RSpec + Cucumber + Spinach by running parallel on multiple CPU cores.
  # gem 'parallel_tests', '~> 4'
end

group :development do
  # The Listen gem listens to file modifications and notifies you about the changes.
  gem 'listen', '~> 3'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring', '~> 4'
  gem 'spring-commands-rspec', '~> 1'
  gem 'spring-watcher-listen', '~> 2'

  # Better Errors replaces the standard Rails error page with a much better and more useful
  # error page.
  gem 'better_errors', '~> 2'

  # Add a comment summarizing the current schema to the top or bottom of each of your models
  gem 'annotate', '~> 3'

  # Required gem to use RailsPanel Chrome extension
  # gem 'meta_request', '~> 0.7'

  # Preview email in the default browser instead of sending it
  # gem 'letter_opener', '~> 1'

  # Use for generate a Entity-Relationship diagram based on the application's Active Record models
  # gem 'rails-erd', '~> 1'

  # Use Capistrano for deployment
  # gem 'capistrano-rails', '~> 1'
end
