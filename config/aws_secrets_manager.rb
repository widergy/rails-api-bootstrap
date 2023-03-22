require 'aws-sdk-secretsmanager'

if ENV['ENABLE_AWS_SECRETS']
  secrets_prefix = 'Bootstrap-'
  # Append the Rails environment to the prefix
  secrets_prefix += ENV['ELK_ENV'] || 'development'
  region = 'us-east-1' # Replace with the region where your secrets are stored
  client = Aws::SecretsManager::Client.new(region: region)

  # Fetch a list of all secrets stored under this AWS account.
  # Requires action "secretsmanager:ListSecrets" for "*" in IAM.
  secrets = client.list_secrets({
    max_results: 100,
    filters: [
      {
        key: 'name',
        values: [secrets_prefix]
      }
    ]
  })

  secrets.secret_list.each do |secret|
    response = client.get_secret_value(secret_id: secret.name)
    secret_data = JSON.parse(response.secret_string)
    secret_data.each do |key, value|
      ENV[key.upcase] = value
    end
  end
end
