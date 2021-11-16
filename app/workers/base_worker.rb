class BaseWorker
  include WorkerHelpers
  include LambdaEventsTracking

  def execute(model, client_id, *args)
    initialize_client(model, client_id)
    initialize_variables(*args)
    perform(*perform_args)
  end

  private

  def initialize_client(model, client_id)
    @client_id = client_id
    @model = model.safe_constantize
  end

  def initialize_variables(*args)
    @args = args
  end

  def perform(*args)
    # @abstract Subclass is expected to implement #service
    # @!method service
    # Define the utility service method to be used for the integration with the Utility's API
    @utility_response = cache_response { utility_service.send(service, *args) }
    return invalid_response(@utility_response) unless successful_response?(@utility_response)
    transform_response
    process_response
    worker_response
  end

  def cache_response
    # Cache is disabled by default.
    # Include CacheResponse module in the workers you wish to use cache.
    yield
  end

  def perform_args
    @args
  end

  def transform_args
    []
  end

  def process_response; end

  def transform_response
    @utility_response.body = transform_response_service.perform(transform_service_method,
                                                                @utility_response, *transform_args)
  end

  def worker_response
    # This is the default response. If any worker wants to return another kind of response, it
    # should re-define worker_response method
    [@utility_response.code, @utility_response.body]
  end

  def client
    @client ||= @model.find(@client_id)
  end

  def utility
    @utility ||= client.utility
  end

  def utility_service
    @utility_service ||= utility.utility_service(client)
  end

  def transform_response_service
    @transform_response_service ||= utility.transform_response_service_dispatcher(client)
  end

  # This should be re-define in case the transform response service name to call is
  # different from the utility service name
  def transform_service_method
    service
  end

  def invalid_response(response)
    # @abstract Subclass is expected to implement #attempt
    # @!method attempt
    # Define attempt method to be used to retrieve error log information
    log_invalid_response(
      response: response, utility: utility, entity: client,
      attempt: attempt
    )
    [response.code, response.body]
  end
end
