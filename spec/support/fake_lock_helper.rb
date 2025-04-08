module Test
  module FakeLock
    class << self
      def locked_by(object)
        object_value = Test::MemcachedAdapter.get(object_name: "Test",
                                                  object_key: object.instance_variable_get(:@object_key))
        object.instance_variable_get(:@object_value) == object_value ? object_value : nil
      end

      def lock_or_find(object)
        if (object_value = locked_by(object)).nil?
          has_locked = false
          Test::MemcachedAdapter.delete(object_name: "Test", object_key: object.instance_variable_get(:@object_key))
          Test::MemcachedAdapter.create(object_name: "Test", object_key: object.instance_variable_get(:@object_key),
                                        object_value: object.instance_variable_get(:@object_value))
          object_value = object.instance_variable_get(:@object_value)
        else
          has_locked = true
        end
        { has_locked:, locked_by: object_value }
      end

      def unlock(object)
        Test::MemcachedAdapter.delete(object_name: "Test", object_key: object.instance_variable_get(:@object_key))
        object.instance_variable_get(:@object_key)
      end
    end
  end
end
