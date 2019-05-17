Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  # The default locale loading mechanism in Rails does not load locale files in nested dictionaries,
  # like we have here. So, for this to work, we must explicitly tell Rails to look further:
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

  # Sets locales to be loaded from rails-18n gem
  config.i18n.available_locales = %i[es en]

  # Sets the default locale to Spanish
  config.i18n.default_locale = :es
end
