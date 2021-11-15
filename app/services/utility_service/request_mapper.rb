module UtilityService
  class RequestMapper
    include PaymentGateways
    def initialize(utility = nil)
      @utility = utility
    end

    # def process_payment(params)
    #   {
    #     token: params['token'],
    #     bin: params['bin'],
    #     lastFourDigits: params['last_four_digits'],
    #     solicitudId: params['request_number'],
    #     email: params['email'],
    #     monto: params['total_amount'],
    #     medio: params['payment_method'],
    #     recibos: params['bills'].map do |bill|
    #       {
    #         nis: bill['client_number'],
    #         id_recibo: bill['external_id'],
    #         saldo: bill['amount']
    #       }
    #     end
    #   }
    # end
  end
end
