class ErrorResponseBuilder
  attr_reader :status, :payload, :utility

  # Usage:
  #   error = ErrorResponseBuilder.new(:unprocessable_entity, utility).add_error(:invalid_token)
  #   [error.status, error.to_h]
  # Based on:
  #   https://stevenpetryk.com/blog/better-rails-api-errors/
  def initialize(status = nil, utility = nil)
    @status = status_code(status)
    @payload = { errors: [] }
    @utility = utility
  end

  def add_status(status)
    @status = status_code(status)
    self
  end

  def add_error(identifier, message: nil, meta: nil)
    payload[:errors] << {
      status: status_code(status),
      code: identifier,
      message: message || translated_error_message(identifier),
      meta: meta
    }
    self
  end

  def to_h
    payload
  end

  # For using in controllers as:
  # "render json: ErrorResponseBuilder.new(identifier, status), status: status"
  def as_json(*)
    payload
  end

  # For using in workers to return the error response
  def to_a
    [status, to_h]
  end

  private

  def status_code(status)
    status.nil? ? nil : Rack::Utils.status_code(status)
  end

  # Looks for a message translation for the given utility.
  # If it does not exist, it returns a default translation
  def translated_error_message(identifier)
    return default_translated_error_message(identifier) if utility.nil?
    I18n.t(
      "errors.messages.#{utility_class_name}.#{identifier}",
      default: default_translated_error_message(identifier)
    )
  end

  def utility_class_name
    utility.class.name.underscore.split('_').first
  end

  def default_translated_error_message(identifier)
    I18n.t("errors.messages.#{identifier}")
  end
end
