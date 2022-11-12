# frozen_string_literal: true

# A module that implements the custom accessor functionality
module Accessors
  # standard attr_accessor, but it saves value history of instance variable
  def attr_accessor_with_history(*names)
    names.each do |name|
      history_arr_name = "@#{name}_history"
      var_name = "@#{name}".to_sym

      # defining getter-method
      define_method(name) { instance_variable_get(var_name) }

      # defining setter-method
      define_method("#{name}=".to_sym) do |value|
        temp_history = instance_variable_get(history_arr_name)

        if temp_history.nil?
          instance_variable_set(history_arr_name, [value])
        else
          temp_history << value
          instance_variable_set(history_arr_name, temp_history)
        end

        instance_variable_set(var_name, value)
      end

      define_method("#{name}_history") { instance_variable_get(history_arr_name) }
    end
  end

  # standard attr_accessor, but with type checking of instance variable
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

# A module that implements validation functionality
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    # method that allows to write validations in class. Validation_param is set to nil by default because
    # we have presence validation, that doesn't accept additional arguments
    def validate(var_name, validation_type, validation_param = nil)
      variable = "@#{var_name}".to_sym

      param = validation_param

      # hash table contains all necessary validations for instance variables
      if class_variable_defined?('@@validations_table')
        table = class_variable_get('@@validations_table')
        if table.key?(variable)
          table[variable][validation_type] = param
        else
          table[variable] = { validation_type => param }
        end
      else
        class_variable_set('@@validations_table', { variable => { validation_type => param } })
      end
    end
  end

  module InstanceMethods
    attr_reader :errors

    def valid?
      # list of errors is filled only after calling valid? method
      @errors = []

      begin
        send(:validate!)
      rescue RuntimeError
        return false
      end

      true
    end

    def validate!
      tmp = self.class.class_variable_get('@@validations_table')
      tmp.each_pair do |variable, val|
        val.each_pair do |validation_type, param|
          send("validate_#{validation_type}", variable, param)
        rescue RuntimeError => e
          @errors << e.message unless @errors.include?(e.message)
          next
        end
      end

      raise RuntimeError unless @errors.empty?
    end

    def validate_presence(variable, _param = nil)
      value = instance_variable_get(variable)
      raise "#{variable} is empty or nil" if value.nil? || (value.instance_of?(String) && value.strip.empty?)
    end

    def validate_type(variable, param)
      value = instance_variable_get(variable)
      raise "Wrong type of variable #{variable}, expected: #{param}" unless value.instance_of?(param)
    end

    def validate_format(variable, param)
      value = instance_variable_get(variable)

      raise "Wrong format of variable #{variable}" if value !~ param
    end
  end
end
