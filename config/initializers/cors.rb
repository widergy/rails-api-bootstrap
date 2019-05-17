# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  if Rails.application.secrets.cors_origins.present?
    allow do
      allowed_origins = Rails.application.secrets.cors_origins.split(':').map do |domain|
        domain.gsub!('.', '\.')
        %r(\Ahttps?:\/\/([a-zA-Z\d-]+\.){0,}#{domain}(:\d+)?\/?\z)
      end

      origins allowed_origins
      resource '*',
               headers: :any,
               methods: %i[get post options patch put delete]
    end
  elsif Rails.env.production?
    # Add the default permitted origin here
    # allow do
    #   origins %r(\Ahttps?:\/\/([a-zA-Z\d-]+\.){0,}example\.com\/?\z)
    #   resource '*',
    #            headers: :any,
    #            methods: %i[get post options patch put delete]
    # end
  else
    allow do
      origins '*'
      resource '*',
               headers: :any,
               methods: %i[get post options patch put delete]
    end
  end
end
