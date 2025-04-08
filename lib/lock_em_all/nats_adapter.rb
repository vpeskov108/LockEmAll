module LockEmAll
  # Модуль для подключений к NATS серверу с использованием гема "nats-pure"
  # NATSAdapter.nats => #<NATS::Client:0x000076b3c1260ca0 ...>
  module NatsAdapter
    require "nats/client"

    extend self

    def nats
      @nats ||= ::NATS.connect(uri, opts)
    end

    # Эта конструкция отправляет все методы контекста .jetstream экземпляру #<NATS::Client>
    # Если метода не существует - вызывается исключение
    def method_missing(method, ...)
      handle_request do
        raise NoMethodError, "undefined method #{method} for #{self}" unless nats.jetstream.respond_to?(method)

        nats.jetstream.send(method, ...)
      end
    end

    def respond_to_missing?(method, include_private = false)
      nats.jetstream.respond_to?(method, include_private)
    end

    private

    def handle_request
      yield
    rescue NATS::IO::Error => e
      raise NATSError, e.message
    end

    def configuration
      Rails.application.config_for(:nats)
    end
  end
end
