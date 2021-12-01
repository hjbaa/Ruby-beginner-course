# frozen_string_literal: true

require_relative 'modules'
require_relative 'metaprogramming_modules'
# класс станции
class Station
  extend AllObjects
  include InstanceCounter
  include Validation
  attr_reader :name, :trains

  validate :name, :presence
  validate :name, :type, String
  def initialize(name)
    @name = name
    validate!
    @trains = []
    self.class.all << self
  end

  def add_train(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def trains_by_type_number(type)
    trains_by_type(type).count
  end

  def send_train(train)
    @trains.delete(train)
  end

  def each_train
    @trains.each { |train| yield(train) if block_given? }
  end
end
