Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web, at: 'sidekiq'
  # This route catches all requests that does not match with any other previous route declared
  match '*uri', to: 'errors#routing_error', via: :all
  match '/', to: 'errors#routing_error', via: :all
end
