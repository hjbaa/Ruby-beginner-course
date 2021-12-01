# frozen_string_literal: true

# геттеры сеттеры
module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      history_arr_name = '@var_history'
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        temp = instance_variable_get(history_arr_name)

        if temp.nil?
          instance_variable_set(history_arr_name, [value])
        else
          temp << value
          instance_variable_set(history_arr_name, temp)
        end

        instance_variable_set(var_name, value)
      end

      define_method("#{name}_history") { instance_variable_get(history_arr_name) }
    end
  end

  def strong_attr_accessor(variable, required_class)
    var_name = "@#{variable}".to_sym
    var_class_name = required_class
    define_method(variable) { instance_variable_get(var_name) }

    define_method("#{variable}=".to_sym) do |value|
      raise 'Wrong class for value!' unless value.instance_of?(var_class_name)

      instance_variable_set(var_name, value)
    end
  end
end

# валидация
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # модуль для методов класса
  module ClassMethods
    def validate(var_name, valid_type, req_validation = nil)
      variable = "@#{var_name}".to_sym
      validation_type = valid_type
      param = req_validation
      # Пробовал внутри этой функции определять метод validate!, но столкнулся с проблемой, что работает только для
      # последнего вызова validate. Т.е. у одной переменной не проверялись бы сразу несколько параметров валидации.
      # Поэтому не смог придумать ничего лучше, кроме как сделать хэш всего того, что нужно проверить на валидность.
      if class_variable_defined?('@@hash_table')
        tmp = class_variable_get('@@hash_table')
        if tmp.has_key?(variable)
          tmp[variable][valid_type] = param
        else
          tmp[variable] = {valid_type => param}
        end
      else
        class_variable_set('@@hash_table', { variable => { validation_type => param } })
      end

    end
  end

  # модуль для инстанс-методов
  module InstanceMethods
    def valid?
      begin
        send(:validate!)
      rescue RuntimeError => e
        puts e.message
        return false
      end

      true
    end

    def validate!
      tmp = self.class.class_variable_get('@@hash_table')
      tmp.each_pair do |variable, val|
        val.each_pair do |validation_type, param|
          value = instance_variable_get(variable)
          case validation_type
          when 'presence'.to_sym
            raise "#{variable} if empty or nil" if value.nil? || (value.instance_of?(String) && value.strip.empty?)
          when 'type'.to_sym
            raise "Wrong type of variable #{variable}" unless value.instance_of?(param)
          else
            raise "Wrong format of variable #{variable}" if value !~ param
          end
        end
      end
      nil
    end
  end
end
