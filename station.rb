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
    trains_by_type(type).count
  end

  def send_train(train)
    @trains.delete(train)
  end
end