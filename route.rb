# frozen_string_literal: true

# класс пути
class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    register_instance
  end

  def insert_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end
end
