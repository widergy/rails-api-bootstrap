class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.ransackable_associations(*)
    reflections.keys
  end

  def self.ransackable_attributes(*)
    attribute_names - %w[token]
  end
end
