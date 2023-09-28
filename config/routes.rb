Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # API Endpoints
  api_version(module: 'api/v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    # namespace :users do
    #   resource :sessions, only: :create
    # end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
  
  get 'api/version', to: 'versions#show'
  
  # Health check routes
  HealthCheck::Engine.routes_explicitly_defined = true
  match "#{HealthCheck.uri}(/:checks)", to: 'health_check#index', via: %i[get post], defaults: { format: :json }
  
  # This route catches all requests that does not match with any other previous route declared
  match '*a', to: 'errors#routing_error', via: :all
  match '/', to: 'errors#routing_error', via: :all
end

# == Route Map
#
#                          Prefix Verb       URI Pattern                                                                                       Controller#Action
#          new_admin_user_session GET        /admin/login(.:format)                                                                            active_admin/devise/sessions#new
#              admin_user_session POST       /admin/login(.:format)                                                                            active_admin/devise/sessions#create
#      destroy_admin_user_session DELETE|GET /admin/logout(.:format)                                                                           active_admin/devise/sessions#destroy
#         new_admin_user_password GET        /admin/password/new(.:format)                                                                     active_admin/devise/passwords#new
#        edit_admin_user_password GET        /admin/password/edit(.:format)                                                                    active_admin/devise/passwords#edit
#             admin_user_password PATCH      /admin/password(.:format)                                                                         active_admin/devise/passwords#update
#                                 PUT        /admin/password(.:format)                                                                         active_admin/devise/passwords#update
#                                 POST       /admin/password(.:format)                                                                         active_admin/devise/passwords#create
#                      admin_root GET        /admin(.:format)                                                                                  admin/dashboard#index
#  batch_action_admin_admin_users POST       /admin/admin_users/batch_action(.:format)                                                         admin/admin_users#batch_action
#               admin_admin_users GET        /admin/admin_users(.:format)                                                                      admin/admin_users#index
#                                 POST       /admin/admin_users(.:format)                                                                      admin/admin_users#create
#            new_admin_admin_user GET        /admin/admin_users/new(.:format)                                                                  admin/admin_users#new
#           edit_admin_admin_user GET        /admin/admin_users/:id/edit(.:format)                                                             admin/admin_users#edit
#                admin_admin_user GET        /admin/admin_users/:id(.:format)                                                                  admin/admin_users#show
#                                 PATCH      /admin/admin_users/:id(.:format)                                                                  admin/admin_users#update
#                                 PUT        /admin/admin_users/:id(.:format)                                                                  admin/admin_users#update
#                                 DELETE     /admin/admin_users/:id(.:format)                                                                  admin/admin_users#destroy
#                 admin_dashboard GET        /admin/dashboard(.:format)                                                                        admin/dashboard#index
#                  admin_comments GET        /admin/comments(.:format)                                                                         admin/comments#index
#                                 POST       /admin/comments(.:format)                                                                         admin/comments#create
#                   admin_comment GET        /admin/comments/:id(.:format)                                                                     admin/comments#show
#                                 DELETE     /admin/comments/:id(.:format)                                                                     admin/comments#destroy
#                     sidekiq_web            /sidekiq                                                                                          Sidekiq::Web
#                         pg_hero            /pghero                                                                                           PgHero::Engine
#                     api_version GET        /api/version(.:format)                                                                            versions#show
#                                 GET|POST   /health_check(/:checks)(.:format)                                                                 health_check#index {:format=>:json}
#                                            /*a(.:format)                                                                                     errors#routing_error
#                                            /                                                                                                 errors#routing_error
#              rails_service_blob GET        /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#        rails_service_blob_proxy GET        /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                 GET        /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#       rails_blob_representation GET        /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
# rails_blob_representation_proxy GET        /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                 GET        /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#              rails_disk_service GET        /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#       update_rails_disk_service PUT        /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#            rails_direct_uploads POST       /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
#                   async_request            /async_request                                                                                    AsyncRequest::Engine
#
# Routes for PgHero::Engine:
#                     space GET  (/:database)/space(.:format)                     pg_hero/home#space
#            relation_space GET  (/:database)/space/:relation(.:format)           pg_hero/home#relation_space
#               index_bloat GET  (/:database)/index_bloat(.:format)               pg_hero/home#index_bloat
#              live_queries GET  (/:database)/live_queries(.:format)              pg_hero/home#live_queries
#                   queries GET  (/:database)/queries(.:format)                   pg_hero/home#queries
#                show_query GET  (/:database)/queries/:query_hash(.:format)       pg_hero/home#show_query
#                    system GET  (/:database)/system(.:format)                    pg_hero/home#system
#                 cpu_usage GET  (/:database)/cpu_usage(.:format)                 pg_hero/home#cpu_usage
#          connection_stats GET  (/:database)/connection_stats(.:format)          pg_hero/home#connection_stats
#     replication_lag_stats GET  (/:database)/replication_lag_stats(.:format)     pg_hero/home#replication_lag_stats
#                load_stats GET  (/:database)/load_stats(.:format)                pg_hero/home#load_stats
#          free_space_stats GET  (/:database)/free_space_stats(.:format)          pg_hero/home#free_space_stats
#                   explain GET  (/:database)/explain(.:format)                   pg_hero/home#explain
#                      tune GET  (/:database)/tune(.:format)                      pg_hero/home#tune
#               connections GET  (/:database)/connections(.:format)               pg_hero/home#connections
#               maintenance GET  (/:database)/maintenance(.:format)               pg_hero/home#maintenance
#                      kill POST (/:database)/kill(.:format)                      pg_hero/home#kill
# kill_long_running_queries POST (/:database)/kill_long_running_queries(.:format) pg_hero/home#kill_long_running_queries
#                  kill_all POST (/:database)/kill_all(.:format)                  pg_hero/home#kill_all
#        enable_query_stats POST (/:database)/enable_query_stats(.:format)        pg_hero/home#enable_query_stats
#                           POST (/:database)/explain(.:format)                   pg_hero/home#explain
#         reset_query_stats POST (/:database)/reset_query_stats(.:format)         pg_hero/home#reset_query_stats
#              system_stats GET  (/:database)/system_stats(.:format)              redirect(301, system)
#               query_stats GET  (/:database)/query_stats(.:format)               redirect(301, queries)
#                      root GET  /(:database)(.:format)                           pg_hero/home#index
#
# Routes for AsyncRequest::Engine:
#    job GET  /jobs/:id(.:format) async_request/jobs#show
