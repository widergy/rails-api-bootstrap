module ParameterValidatorService
  module Base
    include ParamsHandler

    attr_reader :params

    def initialize(utility, controller, params)
      @utility = utility
      @controller = controller
      @params = initialize_params(params)
    end

    # def user_create_session
    #   params.require(%i[email password])
    #   permitted = params.permit(:email, :password)
    #   sanitize_params(add_channel(permitted))
    # end

    private

    attr_reader :utility, :controller

    def initialize_params(params)
      controller&.params || ActionController::Parameters.new(params)
    end

    def validate(method, params, error_identifier: 'invalid_params', utility: nil)
      validation_result = utility.present? ? utility.send(method, params) : send(method, params)
      raise Exceptions::InvalidParameterError, error_identifier unless validation_result
    end

    def add_channel(params)
      params.merge(channel: controller.channel)
    end

    def current_user
      controller.current_user
    end
  end
end
