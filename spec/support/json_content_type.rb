# To deal with this issue when testing endpoints expecting Content-Type: application/json
# https://github.com/rails/rails/issues/27215
module Request
  module JSONContentType
    def get(*args)
      super(*json_args(*args))
    end

    def post(*args)
      super(*json_args(*args))
    end

    def update(*args)
      super(*json_args(*args))
    end

    def patch(*args)
      super(*json_args(*args))
    end

    def put(*args)
      super(*json_args(*args))
    end

    def delete(*args)
      super(*json_args(*args))
    end

    def json_args(path, params = {})
      [path, { **params.merge(as: :json) }]
    end
  end
end
