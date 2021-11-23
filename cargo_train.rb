# frozen_string_literal: true

# класс пассажирского вагона
class CargoTrain < Train
  def initialize(number)
    super(number)
    @type = 'cargo'
  end
end
