# frozen_string_literal: true

# Класс грузового вагона
class CargoCarriage < Carriage

  def initialize
    super { 'cargo' }
  end
end
