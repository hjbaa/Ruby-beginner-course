# frozen_string_literal: true

require_relative 'modules'
require_relative 'metaprogramming_modules'

# класс поезда
class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  extend AllObjects
  attr_accessor :speed
  attr_reader :current_station, :route, :type, :number, :carriages

  NUMBER = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i.freeze
  validate :number, :type, NUMBER

  # регулярное выражение содержит [a-zа-я0-9], а не [\d\w]
  # для того, чтобы можно было вводить русские буквы


  class << self
    def find(number)
      @all.select { |train| train.number == number }
    end
  end

  def initialize(number)
    @number = number
    validate!
    @carriages = []
    @speed = 0
    self.class.all << self
    register_instance
  end

  def stop
    self.speed = 0
  end

  def attach_carriage(carriage)
    @carriages << carriage if type == carriage.type && speed.zero?
  end

  def detach_carriage
    @carriages.delete_at(-1) if speed.zero?
  end

  def route=(train_route)
    @route = train_route
    @current_station = train_route.stations[0]
    @current_station.add_train(self)
  end

  def move_forward
    return if last_station?

    @current_station.send_train(self)
    @current_station = next_station
    @current_station.add_train(self)
  end

  def move_back
    return if first_station?

    @current_station.send_train(self)
    @current_station = prev_station
    @current_station.add_train(self)
  end

  def next_station
    route.stations[route.stations.find_index(current_station) + 1] unless last_station?
  end

  def prev_station
    route.stations[route.stations.find_index(current_station) - 1] unless first_station?
  end

  def each_carriage
    carriages.each { |carriage| yield(carriage) if block_given? }
  end

  protected

  # методы вынесены в protected, т.к. они должны быть у каждого из наследников, но не должны быть доступны пользователю

  def first_station?
    current_station == route.stations[0]
  end

  def last_station?
    current_station == route.stations[-1]
  end

end
