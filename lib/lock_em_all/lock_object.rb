module LockEmAll
  # Сервис для реализации блокировок объектов
  # Объект блокировки содержит следующие параметры:
  #   - object_name: название хранилища объекта блокировки, обычно это название модели,
  #     включая дополнительный ключ ограничения области применения
  #   - object_key: название экземпляра блокировки, обычно это уникальный идентификатор записи БД
  #   - user_id: идентификатор пользователя, который заблокировал запись с идентификатором object_key
  #
  # Класс содержит следующие методы экземпляра:
  #     - lock_or_find: добавляет блокировку если объект не был заблокирован.
  #       возвращает id пользователя (user_id), от которого была блокировка
  #     - unlock: разблокирует объект
  #     - locked_by - возвращает id пользователя (user_id), от которого была блокировка
  class LockObject
    extend LockEmAll::Config
    include adapter

    def initialize(object_params:, user_id: nil)
      @object_name = object_params[:object_name]
      @object_key = object_params[:object_key]
      @user_id = user_id
    end

    # def self.nats
    #   @nats ||= NATSConnection.nats
    # end

    # =======================================================
    # Методы класса
    # =======================================================

    # Возвращает хэш всех заблокированных объектов
    # def self.locked_all(object_name)
    #   bucket = nats.jetstream.key_value(object_name)
    #   bucket.keys.each_with_object({}) do |key, memo|
    #     oblect_values = JSON.parse(bucket.get(key).value)
    #     memo[oblect_values["orig_value"]] = oblect_values["user_id"].to_s
    #   end
    # end

    # Разблокирует все заблокированные объекты
    # def self.unlock_all(object_name, object_key)
    #   bucket = nats.jetstream.key_value(object_name)
    #   bucket.purge(I18n.transliterate(object_key))
    # end

    # Добавляет блокировку (т.е. добавялет ключ @object_key => @user_id в бакет)
    # или возвращает id пользователя (user_id), от которого была блокировка
    # Example
    #  LockObject.new("AAA_001", "1").lock_or_find! => [true, 1]
    #  LockObject.new("AAA_001", "1").lock_or_find! => [false, 1]
    #  false => статья уже была заблокирована, поэтому вызов lock_or_find! блокировку не делает
    # def lock_or_find!
    #   if (user_id = locked_by).nil?
    #     bucket.put(correct_key, { user_id: @user_id, orig_value: @object_key }.to_json)
    #     [false, user_id]
    #   else
    #     [true, @user_id]
    #   end
    # end

    # Разблокирует объект (т.е. удаляет ключ object_key из бакета)
    # def unlock!
    #   bucket.delete(correct_key)
    # end

    # Возвращает user_id или nil? если нет блокировок
    # def locked_by
    # puts "!!!!!!!!!!!!!!!!!!!!!!!!! adapter.locked_by #{adapter.locked_by}"
    # adapter.locked_by
    #   JSON.parse(bucket.get(correct_key).value)["user_id"]
    # rescue NATS::KeyValue::KeyNotFoundError
    #   nil
    # end

    def locked_by
      nil
    end

    def lock_or_find
      nil
    end

    def unlock
      nil
    end

    private

    # def bucket
    #   self.class.nats.jetstream.create_key_value(bucket: @object_name)
    # end

    def correct_key
      I18n.transliterate(@object_key)
    end
  end
end
