# frozen_string_literal: true

# Класс пассажирского вагона
class PassengerCarriage < Carriage
  attr_reader :capacity, :occupied_seats

  def initialize(capacity)
    @type = 'passenger'
    @capacity = capacity
    @occupied_seats = 0
  end

  def take_seat
    raise 'нет свободных мест!' if capacity == occupied_seats

    self.occupied_seats += 1
  end

  def free_seats
    capacity - occupied_seats
  end

  private

  attr_writer :occupied_seats
end
