ENV="$1"
rails db:environment:set RAILS_ENV=${ENV}
rails db:drop RAILS_ENV=${ENV}
rails db:create db:migrate RAILS_ENV=${ENV}
