Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
  # Health check routes
  HealthCheck::Engine.routes_explicitly_defined = true
  match "#{HealthCheck.uri}(/:checks)", to: 'health_check#index', via: %i[get post], defaults: { format: :json }
  # This route catches all requests that does not match with any other previous route declared
  match '*a', to: 'errors#routing_error', via: :all
  match '/', to: 'errors#routing_error', via: :all
end

# == Route Map
#
