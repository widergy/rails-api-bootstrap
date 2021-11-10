module ParamsHandler
  extend ActiveSupport::Concern

  def require_nested(required, params)
    permitted = []
    # Iterates each of the parameters passed in the required hash, requires them if true is passed
    # as value. Then requires the nested params. Recursivity is implemented inside the different
    # require nested methods so require nested is called again if the values to be required are
    # hashes or arrays.
    required.each do |param_key, param_required|
      params.require(param_key) if param_required
      require_nested_object(permitted, param_key, param_required, params)
      require_nested_array(permitted, param_key, param_required, params)
      require_nested_primitive(permitted, param_key, param_required)
    end
    permitted
  end

  def require_nested_object(permitted, param_key, param_required, params)
    # Performs require nested on the value if its a hash. Here, param_required is the hash
    # contained inside param_key. Then pushes the required hash to the permitted collection.
    # Or pushes {} if the hash is empty, making it a wildcard for the permit method (Permitting
    # everything)
    return unless param_required.is_a?(Hash)
    return permitted.push(param_key => {}) if param_required.blank?

    permitted.push(param_key => require_nested(param_required, params[param_key]))
  end

  def require_nested_array(permitted, param_key, param_required, params)
    # Performs require nested on the value if its an array. Each of the values passed inside of the
    # array will be required. Here, param_required is the array contained inside param_key.
    # Then pushes the required array to the permitted collection.
    return unless param_required.is_a?(Array)

    last_permitted = []
    if param_required.first.is_a?(Hash)
      params[param_key].each do |param|
        last_permitted = require_nested(param_required.first, param)
      end
    end
    permitted.push(param_key => last_permitted)
  end

  def require_nested_primitive(permitted, param_key, param_required)
    return if param_required.is_a?(Array) || param_required.is_a?(Hash)

    permitted.push(param_key)
  end

  def indifferent_hash(params)
    return params.to_unsafe_h if params.is_a?(ActionController::Parameters)

    params.with_indifferent_access
  end

  def sanitize_params(params)
    downcase_email(indifferent_hash(params))
  end
end
