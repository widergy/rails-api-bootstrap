module InteractorHelpers
  include ApiResponseHelpers

  private

  def fail_with!(error, status_code, message = nil)
    errors = error_builder(error, status_code, message)
    response = errors.to_h
    context.fail!(response: response, status_code: status_code, errors: errors)
  end

  def error_builder(error, status_code, message)
    errors = context.errors
    errors ||= ErrorResponseBuilder.new(status_code)
    errors.add_error(error, message: message)
    errors
  end
end
