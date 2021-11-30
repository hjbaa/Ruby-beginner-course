# frozen_string_literal: true

require_relative 'modules'

# класс пути
class Route
  include InstanceCounter
  include Validate
  attr_reader :stations

  def initialize(first_station, last_station)
    validate!(first_station, last_station)
    @stations = [first_station, last_station]
    register_instance
  end

  def insert_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end

  private

  def validate!(first_station, last_station)
    raise 'Station could not be nil!' if first_station.nil? || last_station.nil?
  end
end
