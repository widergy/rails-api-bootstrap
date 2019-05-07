# Sidekiq configuration file
require 'sidekiq'
require 'sidekiq/web'

url = ENV['REDIS_URL'] || "redis://#{ENV.fetch('REDIS_1_PORT_6379_TCP_ADDR', '127.0.0.1')}:6379"

Sidekiq.configure_server do |config|
  config.redis = { url: url }
  # https://stackoverflow.com/questions/17606200/log-inside-sidekiq-worker
  Rails.logger = Sidekiq::Logging.logger
end

Sidekiq.configure_client do |config|
  config.redis = { url: url }
end

Sidekiq.default_worker_options = { 'backtrace' => true }

unless Rails.env.development?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_USERNAME', 'rails-api-bootstrap'))) &&
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_PASSWORD', 'rails-api-bootstrap')))
  end
end
