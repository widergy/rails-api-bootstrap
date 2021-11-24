module ApiResponseHelpers
  private

  def successful_response?(response)
    return (200..299).cover?(response) if response.is_a?(Integer)

    return (200..299).cover?(response.first) if response.is_a?(Array)

    (200..299).cover?(response.code)
  end

  def report_warning(message:, utility: nil, user: nil, response: nil, extra: nil)
    Rollbar.warning(
      message,
      utility: utility_log_message(utility),
      user: user_log_message(user),
      response_code: response.try(:code) || response.try(:first),
      response_body: response.try(:body) || response.try(:second),
      extra: extra
    )
  end

  def report_error(error:, attempt:, params: nil, utility: nil, user: nil)
    Rollbar.error(
      error, "Error while #{attempt}",
      utility: utility_log_message(utility),
      params: params,
      user: user_log_message(user)
    )
  end

  def report_info(message:, response:, params: nil, utility: nil)
    Rollbar.info(
      message,
      utility: utility_log_message(utility),
      params: params,
      response_code: response.code,
      response_body: response.body
    )
  end

  def utility_log_message(utility)
    "Utility - ID: #{utility&.id}, NAME: #{utility&.name}"
  end

  def user_log_message(user)
    "User - ID: #{user&.id}, EMAIL: #{user&.email}"
  end

  def account_log_message(account)
    "Account - ID: #{account&.id}, CLIENT_NUMBER: #{account&.client_number}"
  end

  def entity_log_message(entity)
    "#{entity&.class&.name} - ID: #{entity&.id}\n"
  end

  def log_invalid_response(response:, attempt:, utility: nil, entity: nil)
    Rails.logger.error do
      "\n\nError while #{attempt}\n" \
      "#{utility_log_message(utility)}\n" \
      "ENTITY: #{entity_log_message(entity)}" \
      "Response -\n" \
      "Code: #{response.try(:code) || response.try(:first)}\n" \
      "Body: #{response.try(:body) || response.try(:second)}\n\n"
    end
  end
end
