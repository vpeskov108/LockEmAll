module LockEmAll
  # Модуль для подключений к Memcached
  module MemcachedAdapter
    include LockEmAll::MemcachedPool

    def get
      client(object_name).get(object_key)
    end

    def create
      client(object_name).add(object_key, object_value)
    end

    def update
      client(object_name).replace(object_key, object_value)
    end

    def delete
      client(object_name).delete(object_key)
    end
  end
end
