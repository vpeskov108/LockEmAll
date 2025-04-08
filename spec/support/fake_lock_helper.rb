module Test
  module FakeLock
    class << self
      def locked_by(object)
        user_id = Test::MemcachedAdapter.get(object_name: "Test",
                                             object_key: object.instance_variable_get(:@object_key))
        object.instance_variable_get(:@user_id) == user_id ? user_id : nil
      end

      def lock_or_find(object)
        if (user_id = locked_by(object)).nil?
          has_locked = false
          Test::MemcachedAdapter.delete(object_name: "Test", object_key: object.instance_variable_get(:@object_key))
          Test::MemcachedAdapter.create(object_name: "Test", object_key: object.instance_variable_get(:@object_key),
                                        object_value: object.instance_variable_get(:@user_id))
          user_id = object.instance_variable_get(:@user_id)
        else
          has_locked = true
        end
        { has_locked:, locked_by: user_id }
      end

      def unlock(object)
        Test::MemcachedAdapter.delete(object_name: "Test", object_key: object.instance_variable_get(:@object_key))
        object.instance_variable_get(:@object_key)
      end
    end
  end
end
