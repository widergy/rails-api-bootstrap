module FactoryBotMacros
  def attributes_with_foreign_keys(*args)
    FactoryBot.build(*args).attributes.delete_if do |k, _v|
      %w[id type created_at updated_at].member?(k)
    end
  end
end
