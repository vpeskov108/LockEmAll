require "connection_pool"
require "dalli"
require "objspace"

module LockEmAll
  # TO DO description
  module MemcachedPool
    module_function

    def client(namespace)
      client = exists_client_for_namespace(namespace)
      return client unless client.nil?

      ConnectionPool::Wrapper.new do
        Dalli::Client.new(nil, namespace:)
      end
    end

    def exists_client_for_namespace(namespace)
      # https://rubyapi.org/3.4/o/objectspace#method-c-each_object
      ObjectSpace.each_object(ConnectionPool::Wrapper) do |connection|
        return connection if connection.instance_variable_get(:@options)[:namespace] == namespace
      end
      nil
    end
  end
end
