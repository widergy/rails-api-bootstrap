module RequestPerformer # rubocop:disable Metrics/ModuleLength
  extend ActiveSupport::Concern

  private

  HTTP_TIMEOUT_ERRORS = [Net::OpenTimeout, Net::ReadTimeout].freeze

  ALL_HTTP_ERRORS = [
    Net::OpenTimeout, Net::ReadTimeout, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
    Net::ProtocolError, OpenURI::HTTPError, Timeout::Error, Errno::ECONNREFUSED,
    Errno::ECONNRESET, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Errno::EINVAL, EOFError,
    OpenSSL::SSL::SSLError
  ].freeze

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def perform_request(http_verb, url, options = {})
    retries = 0
    url = build_url(url)
    begin
      # If we need to debug the request's output, we can send a "debug_output: Rails.logger"
      # option to the HTTParty call. This method opens a serious security hole. Never use this
      # method in production code.
      HTTParty.send(
        http_verb, url, query: options[:query], body: options[:body], headers: options[:headers],
                        timeout: options[:timeout]
      )
    rescue *HTTP_TIMEOUT_ERRORS => e
      log_error(e, http_verb: http_verb, url: url)
      build_error_response(504, 'gateway_timeout')
    rescue *ALL_HTTP_ERRORS => e
      log_warning(e, http_verb: http_verb, url: url)
      retry if (retries += 1) < Rails.application.secrets.request_retries
      log_and_report_error(e, http_verb: http_verb, url: url)
      notify_failed_external_request
      build_error_response(500, 'internal_server_error')
    rescue ArgumentError => e
      log_and_report_error(e, http_verb: http_verb, url: url)
      build_error_response(501, 'service_unavailable')
    rescue Net::CircuitOpenError => e
      log_and_report_error(e, http_verb: http_verb, url: url)
      disable_utility
      build_error_response(500, 'circuit_open_error')
    rescue StandardError => e
      log_and_report_error(e, http_verb: http_verb, url: url)
      build_error_response(500, 'internal_server_error')
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def build_error_response(code, error, message = nil, meta = nil)
    self.class::Response.new(
      code, ErrorResponseBuilder.new(code).add_error(error, message: message, meta: meta).to_h
    )
  end

  def notify_failed_external_request; end

  def disable_utility; end

  # rubocop:disable Metrics/MethodLength
  def process_response(response, success_response_method: nil, failed_response_method: nil)
    log_response(response) if debug_log_level?
    case response.code
    when (200..299)
      successful_response(response, success_response_method)
    when (400..499)
      return failed_response(response, failed_response_method) if
        failed_response_mapper.respond_to?(failed_response_method)

      unmapped_response(response)
    else
      report_invalid_response(response)
      service_unavailable_response(response)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def debug_log_level?
    Rails.application.config.log_level == :debug
  end

  def successful_response(response, method)
    mapped_response = response_mapper.send(method, response.code, response.parsed_response)
    self.class::Response.new(response.code, mapped_response || {}, response.headers)
  end

  def failed_response(response, method)
    mapped_response = process_failed_response(response, method)
    build_error_response(response.code, service_error_identifier, mapped_response&.dig(:message),
                         mapped_response&.dig(:meta))
  end

  def process_failed_response(response, method)
    return unless response.parsed_response.is_a?(Hash) || response.parsed_response.nil?

    failed_response_mapper.send(method, response.code, response.parsed_response)
  end

  def unmapped_response(response)
    return response if response.is_a?(self.class::Response)

    build_error_response(response.code, service_error_identifier, response.parsed_response)
  end

  def service_unavailable_response(response)
    return response if response.is_a?(self.class::Response)

    build_error_response(response.code, service_error_identifier, service_unavailable_message)
  end

  def replace_url(url, values = {})
    return if url.blank?

    # Inject iterates over each value passed in values taking url as base and applies
    # the given block to the base.
    values.inject(url) { |new_url, (key, value)| new_url.gsub(key.to_s, value.to_s) }
  end

  def body_for(method, *args)
    request_mapper.send(method, *sanitize_args(args))
  end

  def sanitize_args(args)
    args.map { |arg| sanitize_param(arg) }
  end

  def sanitize_param(param)
    return param.to_unsafe_h if param.is_a?(ActionController::Parameters)
    return param.with_indifferent_access if param.is_a?(Hash)

    param
  end

  def formatted_body(body, content_type)
    return body.to_json if content_type == 'application/json'

    body
  end

  def request_log_message(request)
    http_method = request.http_method.name.demodulize.upcase
    "#{http_method} #{request.path}"
  end

  def utility_log_message
    "Utility - ID: #{@utility.id}, NAME: #{@utility.name}"
  end

  def request_body_log(request)
    body = request.options[:body]
    # When we send a body with content-type application/json, we use body.to_json
    return JSON.parse(body).filtered if body.is_a?(String)

    body&.filtered
  end

  def log_error(e, http_verb: nil, url: nil)
    Rails.logger.error do
      "\n\nError for Utility: #{@utility.name} & request: #{http_verb} #{url} \n" \
        "#{e.message} \n #{e.backtrace.join("\n")}\n\n"
    end
  end

  def log_warning(e, http_verb: nil, url: nil)
    Rails.logger.warn do
      "\n\nWarning for Utility: #{@utility.name} & request: #{http_verb} #{url} \n" \
        "#{e.message}\n\n"
    end
  end

  def log_and_report_error(e, http_verb: nil, url: nil)
    log_error(e, http_verb: http_verb, url: url)
    Rollbar.error(e, utility: @utility.name, url: "#{http_verb} #{url}")
  end

  def log_and_report_warning(e, http_verb: nil, url: nil)
    log_warning(e, http_verb: http_verb, url: url)
    Rollbar.warning(e, utility: @utility.name, url: "#{http_verb} #{url}")
  end
end
