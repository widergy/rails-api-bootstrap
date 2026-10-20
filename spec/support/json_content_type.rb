# To deal with this issue when testing endpoints expecting Content-Type: application/json
# https://github.com/rails/rails/issues/27215
module Request
  module JSONContentType
    def get(*)
      super(*json_args(*))
    end

    def post(*)
      super(*json_args(*))
    end

    def update(*)
      super(*json_args(*))
    end

    def patch(*)
      super(*json_args(*))
    end

    def put(*)
      super(*json_args(*))
    end

    def delete(*)
      super(*json_args(*))
    end

    def json_args(path, params = {})
      [path, { **params.merge(as: :json) }]
    end
  end
end
