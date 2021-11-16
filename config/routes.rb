Rails.application.routes.draw do

  # API Endpoints
  api_version(module: 'api/v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    # namespace :users do
    #   resource :sessions, only: :create
    # end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web, at: 'sidekiq'
  # This route catches all requests that does not match with any other previous route declared
  match '*a', to: 'errors#routing_error', via: :all
  match '/', to: 'errors#routing_error', via: :all
end

# == Route Map
#
