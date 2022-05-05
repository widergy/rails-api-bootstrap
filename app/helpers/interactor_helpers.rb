module InteractorHelpers
  include ApiResponseHelpers

  private

  def fail_with!(error, status_code, message = nil)
    errors = error_builder(error, status_code, message)
    response = errors.to_h
    context.fail!(response:, status_code:, errors:)
  end

  def error_builder(error, status_code, message)
    errors = context.errors
    errors ||= ErrorResponseBuilder.new(status_code)
    errors.add_error(error, message:)
    errors
  end
end
