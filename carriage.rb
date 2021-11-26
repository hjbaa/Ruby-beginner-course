# frozen_string_literal: true

require_relative 'modules'
# Класс пассажирского вагона
class Carriage
  include Manufacturer
  attr_reader :type

  private # нам не нужно, чтобы дочерние классы могли переписывать свой тип, поэтому private

  attr_writer :type
end
