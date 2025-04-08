module Test
  module MemcachedAdapter
    extend LockEmAll::MemcachedPool

    class << self
      def get(object_name:, object_key:)
        client(object_name).get(object_key)
      end

      def create(object_name:, object_key:, object_value:)
        client(object_name).add(object_key, object_value)
      end

      def update(_object_name:, _object_key:)
        client(object_name).replace(object_key, object_value)
      end

      def delete(object_name:, object_key:)
        client(object_name).delete(object_key)
      end
    end
  end
end
