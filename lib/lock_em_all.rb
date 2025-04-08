require_relative "lock_em_all/version"
require_relative "lock_em_all/config"
require_relative "lock_em_all/memcached_pool"
require_relative "lock_em_all/null_adapter"
require_relative "lock_em_all/nats_adapter"
require_relative "lock_em_all/redis_adapter"
require_relative "lock_em_all/memcached_adapter"

# raise "LockEmAll #{LockEmAll::VERSION} only works with Rails framework" unless defined?(Rails::Engine)

# TO DO module LockEmAl description
module LockEmAll
  class Error < StandardError; end

  class << self
    def adapter
      defined?(Rails) ? ::Rails.application.config.lock_object : :none
    end

    def configuration(opts = {})
      @configuration ||= { adapter: }.merge!(opts)
    end
  end
end
