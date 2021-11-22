# frozen_string_literal: true

# класс станции
class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def trains_by_type_number(type)
    @trains.select { |train| train.type == type }.count
  end

  def send_train(train)
    @trains.delete(train)
  end
end

# класс пути
class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def insert_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end
end

# класс поезда
class Train
  attr_accessor :speed
  attr_reader :type, :current_station, :route, :carriage_number

  def initialize(number, type, carriage_number)
    @number = number
    @type = type
    @carriage_number = carriage_number.to_i
    @speed = 0
    @train_route = nil
    @current_station = nil
  end

  def stop
    self.speed = 0
  end

  def attach_carriage
    @carriage_number += 1 if speed.zero?
  end

  def detach_carriage
    @carriage_number -= 1 if speed.zero?
  end

  def route=(train_route)
    @route = train_route
    @current_station = train_route.stations[0]
    @current_station.add_train(self)
  end

  def move_forward
    return nil if last_station?

    @current_station.send_train
    @current_station = route.stations[next_station]
    @current_station.add_train(self)
  end

  def move_back
    return nil if first_station?

    @current_station.send_train
    @current_station = route.stations[prev_station]
    @current_station.add_train(self)
  end

  def next_station
    route.stations[route.stations.find_index(current_station) + 1] unless last_station?
  end

  def prev_station
    route.stations[route.stations.find_index(current_station) - 1] unless first_station?
  end

  private

  def first_station?
    current_station == route.stations[0]
  end

  def last_station?
    current_station == route.stations[-1]
  end


end
