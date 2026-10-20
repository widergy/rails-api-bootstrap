# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password secret token _key crypt salt certificate otp ssn
  authorization api_key access_token refresh_token client_secret
  document_number cbu cuil cuit card_number cvv
]
