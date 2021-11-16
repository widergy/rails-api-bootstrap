module UtilityService
  class Base
    include ServiceBaseHelper

    attr_reader :utility

    def initialize(utility, client)
      @utility = utility
      @base_url = utility.base_url
      @utility_service_methods = build_utility_service_methods
      @client = client
      @default_auth_strategy = :utility_jwt
      @auth_strategies = {
        utility_jwt: utility_external_api_access_token,
        none: nil
      }
    end

    Response = Struct.new(:code, :body, :headers)

    def method_missing(method_name, *_args, &_block)
      return super unless @utility_service_methods.include?(method_name)

      Rails.logger.error do
        "#{utility_log_message} not allowed to call method: #{method_name}"
      end
      Response.new(
        403, ErrorResponseBuilder.new(403).add_error('utility_service_forbidden').to_h
      )
    end

    def respond_to_missing?(method_name, include_private = false)
      @utility_service_methods.include?(method_name) || super
    end

    # def health_check
    #   process_response(
    #     get(@utility.health_check_url, timeout: 30),
    #     success_response_method: :none,
    #     failed_response_method: :none
    #   )
    # end

    # def process_payment(params)
    #   process_response(
    #     post(@utility.payment_url,
    #          body: body_for(:process_payment, params)),
    #     success_response_method: :process_payment, failed_response_method: :default_response
    #   )
    # end

    private

    def build_utility_service_methods
      utility_service_methods = []
      Utility.subclasses.each do |utility_class|
        methods = "UtilityService::#{utility_class.to_s.chomp('Utility')}::Base"
                  .safe_constantize
                  &.instance_methods(false)
        utility_service_methods += methods if methods.present?
      end
      utility_service_methods.compact.uniq
    end

    def user_external_api_access_token
      @client&.external_api_access_token? ? "bearer #{@client.external_api_access_token}" : nil
    end

    def notify_failed_external_request
      @utility.notify_event(event: 'failed_external_request')
    end

    def disable_utility
      @utility.update(active: false)
    end

    def service_error_identifier
      'utility_error'
    end

    def service_unavailable_message
      I18n.t('errors.messages.utility_service_unavailable')
    end

    def request_mapper
      request_mapper_from_service(self)
    end

    def response_mapper
      response_mapper_from_service(self)
    end

    def failed_response_mapper
      failed_response_mapper_from_service(self)
    end

    def log_response(response)
      log_response_from_service(response)
    end

    def report_invalid_response(response)
      report_invalid_response_from_service(response, 'the utility')
    end
  end
end
