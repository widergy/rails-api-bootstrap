module WorkerHelpers # rubocop:disable Metrics/ModuleLength
  include ApiResponseHelpers

  private

  def user_or_nil
    @user ||= User.find_by(id: @user_id)
  end

  def client_or_nil
    @client ||= @model.find_by(id: @client_id)
  end

  def user_or_client_or_nil
    return client_or_nil if @client_id.present?
    user_or_nil
  end

  def error_builder(status_code, error_identifier, message: nil, meta: nil, utility: nil)
    ErrorResponseBuilder.new(status_code, utility)
                        .add_error(error_identifier, message: message, meta: meta)
  end

  def log_invalid_response(response:, attempt:, utility: nil, entity: nil, account: nil)
    Rails.logger.error do
      "\n\nError while #{attempt}\n" \
      "#{utility_log_message(utility)}\n" \
      "ENTITY: #{entity_log_message(entity)}" \
      "#{account_log_message(account)}\n" \
      "Response -\n" \
      "Code: #{response.code}\n" \
      "Body: #{response.body}\n\n"
    end
  end

  def log_and_report_invalid_response(response:, attempt:, utility: nil, user: nil, account: nil)
    log_warning_response(
      response: response, attempt: attempt, utility: utility, user: user, account: account
    )
    report_warning(
      message: "Error while #{attempt}", utility: utility, user: user, account: account,
      response: response
    )
  end

  def log_and_report_error(error:, attempt:, utility: nil, user: nil, account: nil)
    log_error(error: error, attempt: attempt, utility: utility)
    report_error(error: error, attempt: attempt, utility: utility, user: user,
                 account: account)
  end

  def log_warning_response(response:, attempt:, utility: nil, user: nil, account: nil)
    Rails.logger.warn do
      "\n\nError while #{attempt}\n" \
      "#{utility_log_message(utility)}\n" \
      "#{user_log_message(user)}\n" \
      "#{account_log_message(account)}\n" \
      "Response -\n" \
      "Code: #{response&.code}\n" \
      "Body: #{response&.body}\n\n"
    end
  end

  def log_error(attempt:, error:, utility: nil)
    Rails.logger.error do
      "\n\nError while #{attempt}\n" \
      "#{utility_log_message(utility)}\n" \
      "Error: #{error.message}\n" \
      "#{error.backtrace.join("\n")}\n\n"
    end
  end

  def log_info(message:, utility: nil, user: nil, account: nil)
    Rails.logger.info do
      "\n\n" \
      "#{utility_log_message(utility)}\n" \
      "#{user_log_message(user)}\n" \
      "#{account_log_message(account)}\n" \
      "Message: #{message}\n\n"
    end
  end

  def log_warning(message:, response: nil, utility: nil, user: nil, account: nil)
    Rails.logger.warn do
      "\n\n#{message}\n" \
      "#{utility_log_message(utility)}\n" \
      "#{user_log_message(user)}\n" \
      "#{account_log_message(account)}\n" \
      "Response -\n" \
      "Code: #{response&.code}\n" \
      "Body: #{response&.body}\n\n"
    end
  end

  def report_error(error:, attempt:, utility: nil, user: nil, account: nil)
    Rollbar.error(
      error, "Error while #{attempt}",
      utility: utility_log_message(utility),
      user: user_log_message(user),
      account: account_log_message(account)
    )
  end

  def indifferent_hash(params)
    return params.to_unsafe_h if params.is_a?(ActionController::Parameters)
    params.with_indifferent_access
  end

  def downcase_email(params)
    params[:email]&.downcase!
    params
  end

  def sanitize_params(params)
    downcase_email(indifferent_hash(params))
  end

  def should_force_sync?
    @cache_control == 'no-cache'
  end
end
