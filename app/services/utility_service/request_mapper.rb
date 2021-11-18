module UtilityService
  class RequestMapper
    include PaymentGateways
    def initialize(utility = nil)
      @utility = utility
    end
  end
end
