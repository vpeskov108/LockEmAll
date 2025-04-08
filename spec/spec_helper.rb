require "factory_bot"
require "lock_em_all"

# Загружаем модули
Dir.glob("lib/lock_em_all/*.rb").each { |file| require_relative "../#{file}" }

# Загружаем хелперы
Dir.glob("spec/support/*.rb").each { |file| require_relative "../#{file}" }

# Загружаем фабрики
Dir.glob("spec/factories/*.rb").each { |file| require_relative "../#{file}" }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Test class for checking methods LockEmAll::MemcachedAdapter module
class FakeModel
  attr_reader :object_name, :object_key, :object_value

  def initialize(object_name:, object_key:, object_value: nil)
    @object_name = object_name || "Test"
    @object_key = object_key || "Test"
    @object_value = object_value
  end
end
