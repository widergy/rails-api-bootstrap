module LambdaEventsTracking # rubocop:disable Metrics/ModuleLength
  extend ActiveSupport::Concern
  include WorkerHelpers
  include ApiAnalytics
  include LambdaEventsMetadata

  included do
    include HTTParty
    base_uri Rails.application.secrets.api_gateway_lambda_base_url
  end

  def track_entity_event(event:, channel:, **options)
    with_rescue do
      @options = options
      return log_warning_message(errors) if errors.present?

      assign_client_and_model
      @body = track_entity_event_body(event, channel)
      call_and_log_event
    end
  end

  def track_request_event(url:, http_method:, failed:, response:, **options)
    with_rescue do
      @options = options
      check_request_event_body_params(http_method, failed)
      return log_warning_message(errors) if errors.present?

      assign_client_and_model
      @body = track_request_event_body(url, http_method, failed, response)
      call_and_log_event
    end
  end

  def errors
    @errors ||= []
  end

  def append_client(options, client)
    options.merge(client_id: client&.id, model: client&.class)
  end

  private

  attr_reader :body, :lambda_response, :options

  def call_and_log_event
    @lambda_response = track_event
    return log_and_report_warning unless successful_response?(lambda_response)
    log_info_message('Successful event tracking')
  end

  def track_event
    self.class.post('/data', body: body, headers: base_headers.merge(headers))
  end

  # rubocop:disable Metrics/MethodLength
  def track_entity_event_body(event, channel)
    now = Time.zone.now
    {
      event_type: ApiAnalytics::EventsType::ENTITY_ACTION_EVENT,
      entity_id: entity_id(now),
      id_type: entity_event_id_type,
      utility_code: utility_lambda.code,
      entity_name: ApiAnalytics::ENTITIES_NAME[entity_event_id_type],
      event: event,
      channel: channel,
      metadata: options[:metadata],
      app: options[:app_name] || ApiAnalytics::AppName::RAILS_API_BOOTSTRAP,
      timestamp: now
    }.to_json
  end

  def track_request_event_body(url, http_method, failed, response)
    {
      event_type: ApiAnalytics::EventsType::UTILITY_REQUEST_EVENT,
      utility_code: utility_lambda.code,
      url: url,
      http_method: http_method,
      failed: failed,
      response: response,
      body: options[:body],
      params: options[:params],
      timestamp: Time.zone.now
    }.to_json
  end
  # rubocop:enable Metrics/MethodLength

  # controller use case purposes
  def assign_client_and_model
    @model ||= options[:model]
    @client_id ||= options[:client_id]
  end

  def entity_event_id_type
    @entity_event_id_type ||= user_or_client_or_nil&.class&.to_s&.downcase ||
                              ApiAnalytics::ANONYMOUS_USER
  end

  def entity_id(date)
    user_or_client_or_nil&.id || Digest::SHA256.hexdigest(date.to_f.to_s)
  end

  def check_request_event_body_params(http_method, failed)
    errors.push('Invalid http method value') unless valid_http_method? http_method
    errors.push('Invalid failed value') unless [true, false].include? failed
  end

  def valid_http_method?(method)
    %w[GET POST DELETE PUT PATCH].include?(method)
  end

  def utility_lambda
    @utility_lambda ||= options[:utility] || Utility.find_by(id: user_or_client_or_nil&.utility_id)
  end

  def base_headers
    @base_headers ||= { 'x-api-key': api_gateway_key }
  end

  def api_gateway_key
    @api_gateway_key ||= Rails.application.secrets.api_gateway_lambda_key
  end

  def headers
    @headers ||= {}
  end

  def with_rescue
    yield
  rescue StandardError => e
    lambda_event_tracking_error(e)
  end

  def lambda_event_tracking_error(error)
    log_and_report_error(error: error, attempt: attempt, utility: utility_lambda,
                         user: user_or_client_or_nil)
  end

  def log_and_report_warning
    log_and_report_invalid_response(response: lambda_response, utility: utility_lambda,
                                    user: user_or_client_or_nil, attempt: attempt)
  end

  def log_warning_message(message)
    log_warning(message: message, utility: utility_lambda, user: user_or_client_or_nil)
  end

  def log_info_message(message)
    log_info(message: message, utility: utility_lambda, user: user_or_client_or_nil)
  end

  def attempt
    'Lambda events tracking'
  end
end
