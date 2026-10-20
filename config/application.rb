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
require 'prometheus/client'
require 'prometheus/client/data_stores/direct_file_store'
# require 'fog/core'
# Fog::Logger[:deprecation] = nil

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApiBootstrap
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

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

    # ActiveStorage is loaded but unused here. Without this, booting warns that
    # generating variants needs the image_processing gem. An app that does store
    # files adds that gem and removes this line.
    config.active_storage.variant_processor = :disabled

    # Adds lib to the autoload and eager load paths. Rails 7.1+ replaces the manual
    # eager_load_paths push; `ignore` keeps the non-reloadable subdirectories out.
    config.autoload_lib(ignore: %w[assets tasks])

    # Sets the default time zone
    config.time_zone = 'America/Argentina/Buenos_Aires'

    # Application settings, reachable as Rails.configuration.settings.<key>
    config.settings = config_for(:settings)

    # Tell your app to use the Rack::Attack middleware
    config.middleware.use Rack::Attack

    # Middleware for ActiveAdmin
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # APM service name
    config.elastic_apm.service_name = 'rails-api-bootstrap'

    Prometheus::Client.config.data_store = Prometheus::Client::DataStores::DirectFileStore.new(dir: '/tmp/prometheus_direct_file_store')
  end
end
