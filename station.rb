# frozen_string_literal: true

require_relative 'modules'
# класс станции
class Station
  extend AllObjects
  include InstanceCounter
  include Validate
  attr_reader :name, :trains

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

  private

  def validate!
    raise 'Name could not be nil!' if name.nil?
  end
end
