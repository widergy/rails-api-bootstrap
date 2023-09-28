module AttributeJsonParser
  extend ActiveSupport::Concern

  included do
    before_save :parse_json_attributes
  end

  private

  def parse_json_attributes
    attributes = self.class::JSON_ATTRIBUTES
    return if attributes.empty?
    process_json_parsing(attributes)
  end

  def process_json_parsing(attributes)
    attributes.each do |attr|
      next unless send(attr).is_a?(String)
      # When a validation fails saving the record in ActiveAdmin, the attribute is
      # escaped to string. This happens n times the user saves the record, so the attribute
      # comes multiple times escaped. So, to fix the value we need to loop until
      # the value stops being String (probably either Hash or Array).
      loop_attribute(attr)
    rescue JSON::ParserError
      errors[attr.to_sym] << 'must be a valid json'
      throw(:abort)
    end
  end

  def loop_attribute(attr)
    loop do
      send("#{attr}=", JSON.parse(send(attr.to_sym)))
      break unless send(attr.to_sym).is_a?(String)
    end
  end
end
