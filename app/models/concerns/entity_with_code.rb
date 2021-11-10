module EntityWithCode
  extend ActiveSupport::Concern

  included do
    validates :code, uniqueness: true

    after_save :generate_entity_code
  end

  private

  def generate_entity_code
    return if code.present?

    self.code = "#{self.class.name.split('::').first.underscore.singularize}_#{id}"
    save!
  end

  # Setting code in entity duplication https://blog.appsignal.com/2019/02/26/diving-into-dup-and-clone.html
  def initialize_dup(original_entity)
    self.code = nil
    super
  end
end
