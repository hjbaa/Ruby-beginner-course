# frozen_string_literal: true

require_relative 'carriage'

# Класс грузового вагона
class CargoCarriage < Carriage
  attr_reader :volume, :occupied_volume

  def initialize(volume)
    @type = 'cargo'
    @volume = volume
    @occupied_volume = 0
  end

  def put_load(volume)
    raise 'нет свободного места!' if free_volume < volume

    self.occupied_volume += volume
  end

  def free_volume
    volume - occupied_volume
  end

  private

  attr_writer :occupied_volume
end
