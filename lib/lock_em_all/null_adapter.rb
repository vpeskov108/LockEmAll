module LockEmAll
  # Модуль для ...
  module NullAdapter
    %i[get create update delete].each do |method|
      define_method method do
        nil
      end
    end
  end
end
