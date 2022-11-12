# frozen_string_literal: true

require_relative 'metaprogramming_modules'

class TestAccessorWithHistory
  extend Accessors
  attr_accessor_with_history :dummy1, :dummy2

  def initialize
    @dummy1 = nil
    @dummy2 = nil
  end
end

class TestStrongAttrAccessor
  extend Accessors
  strong_attr_accessor :strong_accessor_test, Integer

  def initialize
    @strong_accessor_test = nil
  end
end

class TestPresenceValidation
  include Validation

  attr_accessor :presence_test

  validate :presence_test, :presence

  def initialize
    @presence_test = nil
  end
end

class TestTypeValidation
  include Validation

  attr_accessor :type_integer_test

  validate :type_integer_test, :type, Integer

  def initialize
    @type_integer_test = nil
  end
end

class TestFormatValidation
  include Validation

  attr_accessor :format_test

  validate :format_test, :format, /\d/

  def initialize
    @format_test = nil
  end
end

class TestManyValidationsToOneVar
  include Validation

  attr_accessor :dummy

  validate :dummy, :presence
  validate :dummy, :type, String
  validate :dummy, :format, /\d/

  def initialize
    @dummy = nil
  end
end
