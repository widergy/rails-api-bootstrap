require_relative 'boot'
require_relative 'aws_secrets_manager'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"
require 'wannabe_bool'
# require 'fog/core'
# Fog::Logger[:deprecation] = nil

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApiBootstrap
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.app_generators.scaffold_controller = :scaffold_controller

    # Configure Active Job to work with Sidekiq
    config.active_job.queue_adapter = :sidekiq

    # Adds lib folder to eager load paths
    config.eager_load_paths << Rails.root.join('lib')

    # Sets the default time zone
    config.time_zone = 'America/Argentina/Buenos_Aires'

    # Using legacy connection handling is deprecated
    config.active_record.legacy_connection_handling = false

    # Tell your app to use the Rack::Attack middleware
    config.middleware.use Rack::Attack

    # Middleware for ActiveAdmin
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
  end
end
