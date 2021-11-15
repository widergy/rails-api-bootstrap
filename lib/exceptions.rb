# This class should be used to define custom exceptions
module Exceptions
  class InvalidParameterError < StandardError; end
  class InvalidCurrentClientError < StandardError; end
  class ClientForbiddenError < StandardError; end
  class ClientUnauthorizedError < StandardError; end
  class UtilityUnavailableError < StandardError; end
end
