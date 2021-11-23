# frozen_string_literal: true

# Класс пассажирского вагона
class PassengerCarriage < Carriage

  def initialize
    super { 'passenger' }
  end
end
