module LockEmAll
  # TO DO description
  module Config
    module_function

    def adapter
      case LockEmAll.configuration[:adapter]
      when :none then LockEmAll::NullAdapter
      when :memcached then LockEmAll::MemcachedAdapter
      when :nats then LockEmAll::NatsAdapter
      when :redis then LockEmAll::RedisAdapter
      end
    end
  end
end
