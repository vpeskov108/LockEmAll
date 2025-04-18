# LockEmAll

Блокировка объектов Rails приложения. Блокировка - это установленный признак в именованном хранилище. Структура блокировки:

object_name: {\
  object_key_1: object_value_1,\
  object_key_2: object_value_1,\
  .............................\
  object_key_n: object_value_n\
}

Множественные блокировки не допускаются. Т.е. нельзя сделать так: { object_key_1:  [object_value_1, object_value_2] }, или так:

object_name: {\
  object_key_1: object_value_1,\
  object_key_1: object_value_2\
}


## Описание

### Черновик

Гем содержит два уровня абстракции. На верхнем уровне класс, осуществляющий функционал блокировок LockObject, отвечает на методы locked_by , lock_or_find , unlock , которые реализуют основной функционал (поиск, блокировку, разблокирование).
На втором уровне абстракции реализованы адаптеры хранилищ, которые содержат методы доступа к данным (get, create, update, delete) и отвечают за специфику доступа к своим хранилищам.
Для упрощения реализации соединение адаптеров с хранилищами оборачивается в ConnectionPool::Wrapper.

Особенности реализации

Используемый адаптер gem получает из Rails приложения. Для этого в конфигурацию добавляется параметр Rails.application.config.lock_object. Он имеет значения: :memcached , :redis , :nats , :none.

Адаптеры выполнены в виде модулей, которые подключаются к классу LockObject и реализуют вызовы методов доступа к данным методами конкретного адаптера, указанного в конфигурации. Более подробно техническая часть будет описана в MR.

## установка

 - установка зависимостей
   команда `bin/setup`

- сборка версии гема`
    команда `gem build lock_em_all.gemspec`

... не закончено..
