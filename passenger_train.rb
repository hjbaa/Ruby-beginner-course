# frozen_string_literal: true

# класс пассажирского поезда
class PassengerTrain < Train
  def initialize(number)
    super(number)
    @type = 'passenger'
  end

end
