# frozen_string_literal: true

# Класс пассажирского вагона
class Carriage
  attr_reader :type

  def initialize
    self.type = yield
  end

  private # нам не нужно, чтобы дочерние классы могли переписывать свой тип, поэтому private

  attr_writer :type

end
