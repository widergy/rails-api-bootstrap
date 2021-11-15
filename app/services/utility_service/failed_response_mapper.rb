module UtilityService
  class FailedResponseMapper
    def initialize(utility = nil)
      @utility = utility
    end

    def none(_response_code, response_body)
      response_body
    end

    def default_response(_response_code, response_body)
      {
        message: fetch_response_message(response_body),
        title: fetch_response_title(response_body)
      }
    end

    private

    def fetch_response_message(response_body)
      response_body.is_a?(Hash) ? format_response_message(response_body) : nil
    end

    def fetch_response_title(response_body)
      response_body.is_a?(Hash) ? format_response_title(response_body) : nil
    end

    def to_downcase(response)
      response.transform_keys(&:downcase)
    end

    def format_response_message(response)
      response = to_downcase(response)
      response['message'] || response['mensaje']
    end

    def format_response_title(response)
      response = to_downcase(response)
      response['title'] || response['titulo']
    end
  end
end
