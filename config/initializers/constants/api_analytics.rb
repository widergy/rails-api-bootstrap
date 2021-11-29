module ApiAnalytics
  ANONYMOUS_USER = 'anonymous'.freeze
  ENTITIES_NAME = {
    'adminuser' => 'usuario administrador',
    'user' => 'usuario',
    ANONYMOUS_USER => 'usuario'
  }.freeze

  module AppName
    RAILS_API_BOOTSTRAP = 'Rails-Api-Bootstrap'.freeze
  end

  module EventsType
    ENTITY_ACTION_EVENT = 'entity_action'.freeze
    UTILITY_REQUEST_EVENT = 'utility_request'.freeze
  end

  # module Events
  #   FORM_RESPONSE_CREATION = 'form_response_creation'.freeze
  #   PAYMENT_CREATION = 'payment_creation'.freeze
  #   PAYMENT_IDENTIFICATION = 'payment_identification'.freeze
  #   PAYMENT_SUCCESS_CALLBACK = 'payment_success_callback'.freeze
  #   PAYMENT_FAILURE_CALLBACK = 'payment_failure_callback'.freeze
  # end
end
