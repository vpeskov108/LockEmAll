module LockEmAll
  # Сервис для реализации блокировок объектов
  # Объект блокировки содержит следующие параметры:
  #   - object_name: название хранилища объекта блокировки, обычно это название модели,
  #     включая дополнительный ключ ограничения области применения
  #   - object_key: название экземпляра блокировки, обычно это уникальный идентификатор записи БД
  #   - object_value: идентификатор блокировщика, который заблокировал запись с идентификатором object_key
  #
  # Класс содержит следующие методы экземпляра:
  #     - lock_or_find: добавляет блокировку если объект не был заблокирован.
  #       возвращает id блокировщика (блокировщика), от которого была блокировка
  #     - unlock: разблокирует объект, на который указывает object_key
  #     - locked_by - возвращает id блокировщика (object_value), от которого была блокировка
  class LockObject
    extend LockEmAll::Config
    include adapter

    def initialize(object_params:, object_value: nil)
      @object_name = object_params[:object_name]
      @object_key = object_params[:object_key]
      @object_value = object_value
    end

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

    def correct_key
      I18n.transliterate(@object_key)
    end
  end
end
