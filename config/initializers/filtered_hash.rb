class Hash
  def filtered
    ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters).filter(self)
  end
end
