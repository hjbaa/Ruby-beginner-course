# frozen_string_literal: true

# Модули все в одном файле для более удобной проверки
# Потом собираюсь разделить на разные файлы

# модуль производтеля для подключения в train и carriage
module Manufacturer
  attr_accessor :manufacturer
end

# модуль подсчета созданных объектов
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # модуль методов класса
  module ClassMethods
    def instances
      @instances ||= 0
    end

    def increase_objects_num
      if instances.nil?
        @instances = 1
      else
        @instances += 1
      end
    end
  end

  # модуль инстанс методов
  module InstanceMethods
    protected

    def register_instance
      self.class.increase_objects_num
    end
  end
end

# модуль для создания массива всех экземпляров класса
# нужен для подключения в station по заданию, в train для реализации метода find
module AllObjects
  def all
    @all ||= []
  end
end

# модуль для подключения в классы train, station и route. Этот код одинаков во всех перечисленных классах =>
# лучше вынести в модуль, чтобы избежать дублирование кода
module Validate
  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end
end
