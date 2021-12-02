# frozen_string_literal: true

# файл для тестирования функций модуля метапрограммирования

require_relative 'metaprogramming_modules'

# класс для тестирования
class Test1
  include Validation

  attr_accessor :a

  validate :a, :presence

  def initialize
    @a = nil
  end
end

# класс для тестирования
class Test2
  include Validation

  attr_accessor :a

  validate :a, :type, Integer

  def initialize
    @a = nil
  end
end

# класс для тестирования
class Test3
  include Validation

  attr_accessor :a

  validate :a, :format, /\d/

  def initialize
    @a = nil
  end
end

# класс для тестирования
class Test4
  include Validation

  attr_accessor :a

  validate :a, :presence
  validate :a, :type, String
  validate :a, :format, /\d/

  def initialize
    @a = nil
  end
end

class Test5
  extend Accessors
  attr_accessor_with_history :a, :b

  strong_attr_accessor :c, Integer
  def initialize
    @a = nil
    @b = nil
    @c = nil
  end
end
