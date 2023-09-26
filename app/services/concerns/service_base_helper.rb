module ServiceBaseHelper # rubocop:disable Metrics/ModuleLength
  include RequestPerformer

  private

  def utility_external_api_access_token
    @utility.external_api_access_token? ? "bearer #{@utility.external_api_access_token}" : nil
  end

  # rubocop:disable Metrics/ParameterLists
  def get(url, query: nil, timeout: 60, auth_strategy: @default_auth_strategy,
          custom_headers: {})
    log_request('GET', url, query: query, auth_strategy: auth_strategy, timeout: timeout)
    perform_request(
      :get, url, query: query, timeout: timeout,
                 headers: headers(auth_strategy, custom_headers: custom_headers)
    )
  end

  def post(url, query: nil, body: {}, content_type: 'application/json', timeout: 60,
           auth_strategy: @default_auth_strategy, custom_headers: {})
    log_request('POST', url, query: query, auth_strategy: auth_strategy,
                             body: body, timeout: timeout, content_type: content_type)
    perform_request(
      :post, url, query: query, body: formatted_body(body, content_type),
                  timeout: timeout,
                  headers: headers(auth_strategy, content_type: content_type,
                                                  custom_headers: custom_headers)
    )
  end

  def delete(url, query: nil, body: {}, content_type: 'application/json', timeout: 60,
             auth_strategy: @default_auth_strategy, custom_headers: {})
    log_request('DELETE', url, query: query, auth_strategy: auth_strategy,
                               body: body, timeout: timeout, content_type: content_type)
    perform_request(
      :delete, url, query: query, body: formatted_body(body, content_type),
                    timeout: timeout,
                    headers: headers(auth_strategy, content_type: content_type,
                                                    custom_headers: custom_headers)
    )
  end

  def put(url, query: nil, body: {}, content_type: 'application/json', timeout: 60,
          auth_strategy: @default_auth_strategy, custom_headers: {})
    log_request('PUT', url, query: query, auth_strategy: auth_strategy,
                            body: body, timeout: timeout, content_type: content_type)
    perform_request(
      :put, url, query: query, body: formatted_body(body, content_type),
                 timeout: timeout,
                 headers: headers(auth_strategy, content_type: content_type,
                                                 custom_headers: custom_headers)
    )
  end

  def log_request(http_verb, url, query: nil, body: nil, auth_strategy: nil, timeout: nil,
                  content_type: nil)
    Rails.logger.info do
      "\n\nSending #{http_verb} request to URL: #{build_url(url)} \n" \
        "Utility - ID: #{@utility&.id}, NAME: #{@utility&.name} \n" \
        "#{client_log_request(@client)}" \
        "Auth: #{auth_strategy_present?(auth_strategy)} - Strategy: #{auth_strategy} \n" \
        "Content-Type: #{content_type} \n" \
        "Body: #{body&.filtered&.as_json} \n" \
        "Query params: #{query&.filtered&.as_json} \n" \
        "Timeout: #{timeout} \n\n"
    end
  end
  # rubocop:enable Metrics/ParameterLists

  def client_log_request(client)
    return if client.nil?
    "#{client&.class&.name} - ID: #{client&.id} \n" \
      "#{client&.identification_key}: #{client&.identification} \n"
  end

  def auth_strategy_present?(strategy)
    @auth_strategies && @auth_strategies[strategy].present?
  end

  def build_url(url)
    return url if url.blank? || url.starts_with?('http')
    "#{@base_url.chomp('/')}/#{url.reverse.chomp('/').reverse}"
  end

  def headers(auth_strategy, content_type: nil, custom_headers: {})
    headers = {
      'Content-Type' => content_type,
      'Authorization' => @auth_strategies[auth_strategy]
    }.merge(custom_headers)
    # We don't want to send headers without value nor an empty hash
    headers.compact.presence
  end

  def log_response_from_service(response, service = nil)
    Rails.logger.info do
      receiving_response(service)
      "ID: #{@utility&.id}, NAME: #{@utility&.name} \n" \
        "Status Code: #{response&.code} \n" \
        "Content-Type: #{response&.headers&.fetch('content-type', {})} \n" \
        "Body:#{response&.body}\n" \
    end
  end

  def receiving_response(service)
    if service.nil?
      "\n\nReceiving response from Utility - " \
    else
      "\n\nReceiving response from #{service} API for Utility - " \
    end
  end

  # rubocop:disable Metrics/MethodLength

  def report_invalid_response_from_service(response, service)
    return unless response.is_a?(HTTParty::Response)
    Rollbar.error(
      "The server got an invalid response from #{service}",
      utility: utility_log_message,
      client: @client&.log_message,
      request: request_log_message(response.request),
      request_query_params: response.request.options[:query]&.filtered,
      request_body: request_body_log(response.request),
      response_code: response.code,
      response_body: response.body
    )
  end

  # rubocop:enable Metrics/MethodLength

  def request_mapper_from_service(service)
    @request_mapper ||= service.class.parent::RequestMapper.new(@utility)
  end

  def response_mapper_from_service(service)
    @response_mapper ||= service.class.parent::ResponseMapper.new(@utility)
  end

  def failed_response_mapper_from_service(service)
    @failed_response_mapper ||= service.class.parent::FailedResponseMapper.new(@utility)
  end

  def service_unavailable_message
    I18n.t('errors.messages.form_response_manager_service_unavailable')
  end
end
