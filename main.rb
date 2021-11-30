# frozen_string_literal: true

if Gem.win_platform? # для подключения русского языка в консоли
  Encoding.default_external = Encoding.find(Encoding.locale_charmap) # явное указание кодировки не помогало
  Encoding.default_internal = __ENCODING__
  [$stdin, $stdout].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative 'carriage'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'cargo_carriage'
require_relative 'passenger_train'
require_relative 'passenger_carriage'
require_relative 'route'
require_relative 'station'


# Класс интерфейса пользователя
class Main

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def start
    choice = commands_list
    loop do
      puts "\n\n ------------ \n\n"
      case choice
      when 1
        add_station
      when 2
        add_train
      when 3
        add_route
      when 4
        add_station_for_route
      when 5
        assign_route
      when 6
        add_carriage
      when 7
        delete_carriage
      when 8
        move_train
      when 9
        show_stations
      when 10
        show_trains_on_station
      when 11
        fill_carriage
      when 12
        show_trains_carriages
      else
        break
      end
      puts "\n\n ------------ \n\n"
      choice = commands_list
    end
  end

  private # внутренние реализации класса Main, не должны быть видны пользователю

  def commands_list
    puts '1 - создать станцию'
    puts '2 - создать поезд'
    puts '3 - создать маршрут'
    puts '4 - добавить/удалить станцию из маршрута'
    puts '5 - назначить маршрут поезду'
    puts '6 - добавить вагон поезду'
    puts '7 - отцепить вагон от поезда'
    puts '8 - переместить поезд по маршруту'
    puts '9 - просмотреть список станций'
    puts '10 - посмотреть список поездов на станции'
    puts '11 - занять место/объем в вагоне'
    puts '12 - показать вагоны у поезда'
    puts '13 - выход из программы'
    puts 'Ваш ответ: '
    n = gets.to_i
  end

  def add_station
    begin
      puts 'Введите название станции: '
      name = gets.chomp
      @stations << Station.new(name)
    rescue RuntimeError => e
      puts e.message
      puts 'Введите название заново!'
      retry
    end
    puts 'Успешно добавлено!'
  end

  def show_stations
    if @stations.empty?
      puts 'Нет станций!'
      nil
    end
    i = 1
    @stations.each do |station|
      puts "Станция №#{i} - #{station.name}"
      i += 1
    end
  end

  def show_trains_on_station
    puts 'Введите название станции:'
    station_name = gets.chomp
    station = station_by_name(station_name)
    if station.trains.empty?
      puts 'На станции нет поездов!'
    else
      puts 'На станции находятся поезда со следующими номерами: '
      station.each_train { |train| puts "Поезд №#{train.number}" }
    end
  end

  def add_train
    begin
      puts 'Введите номер поезда:'
      train_number = gets.chomp
      puts 'Введите тип поезда:'
      puts '1 - грузовой'
      puts '2 - пассажирский'
      n = gets.to_i
      case n
      when 1
        @trains << CargoTrain.new(train_number)
      when 2
        @trains << PassengerTrain.new(train_number)
      end
    rescue RuntimeError => e
      puts e.message
      puts 'Введите номер заново!'
      retry
    end
    puts 'Поезд добавлен!'
  end

  def add_route

    begin
      puts 'Введите название начальной станции:'
      first_station_name = gets.chomp
      puts 'Введите название конечной станции:'
      last_station_name = gets.chomp
      first_station = station_by_name(first_station_name)
      last_station = station_by_name(last_station_name)
      @routes << Route.new(first_station, last_station)
    rescue RuntimeError => e
      puts e.message
      puts 'Введите заново!'
      retry
    end
    puts 'Маршрут добавлен!'
  end

  def add_station_for_route
    begin
      show_routes
    rescue RuntimeError => e
      puts e.message
      puts 'Добавьте сначала маршрут!'
      return nil
    end

    puts 'Выберите маршрут для редактирования:'
    route_number = gets.to_i
    route = @routes[route_number - 1]
    puts '1 - добавить станцию'
    puts '2 - удалить станцию'
    puts 'Ваш ответ: '
    n = gets.to_i

    puts 'Введите название промежуточной станции: '
    station_name = gets.chomp
    station = station_by_name(station_name)
    case n
    when 1
      if @stations.find(station).nil?
        route.insert_station(station)
        puts 'Станция добавлена в маршрут!'
      else
        puts 'Станция уже в маршруте!'
      end

    when 2
      if @routes.count <= 2
        puts 'Нельзя удалить станцию!'
        return nil
      end

      if @routes.find(station).nil?
        puts 'Станции нет в маршруте!'
        return nil
      end
      route.delete_station(station)
      puts 'Станция удалена из маршрута!'
    end
  end

  def assign_route
    begin
      show_trains
    rescue RuntimeError => e
      puts e.message
      puts 'Добавьте сначала поезд!'
      return nil
    end

    puts 'Введите номер поезда, которому необходио назначить маршрут:'
    train_number = gets.chomp

    begin
      show_routes
    rescue RuntimeError => e
      puts e.message
      puts 'Добавьте сначала маршрут!'
      return nil
    end

    puts 'Введите номер маршрута, который необходимо назначить:'
    route_number = gets.to_i
    train = train_by_number(train_number)
    route = @routes[route_number - 1]
    train.route = route
    puts 'Маршрут назначен!'
  end

  def add_carriage
    begin
      show_trains
    rescue RuntimeError => e
      puts e.message
      puts 'Добавьте сначала поезд!'
      return nil
    end

    puts 'Введите номер поезда, к которому необходимо прицепить вагон:'
    train_number = gets.chomp
    train = train_by_number(train_number)
    if train.type == 'passenger'
      puts 'Введите количество мест в вагоне:'
      seats_number = gets.to_i
      carriage = PassengerCarriage.new(seats_number)
    else
      puts 'Введите вместимость (объем) вагона:'
      volume = gets.to_i
      carriage = CargoCarriage.new(volume)
    end
    train.attach_carriage(carriage)
    puts 'Вагон прицеплен!'
  end

  def delete_carriage
    begin
      show_trains
    rescue RuntimeError => e
      puts e.message
      puts 'Добавьте сначала поезд!'
      return nil
    end

    puts 'Введите номер поезда, от которого необходимо отцепить вагон:'
    train_number = gets.chomp
    train = train_by_number(train_number)
    unless train.carriages.count.positive?
      puts 'Вагонов нет!'
      return nil
    end
    train.detach_carriage
    puts 'Вагон отцеплен!'
  end

  def move_train
    begin
      show_trains
    rescue RuntimeError => e
      puts e.message
      puts 'Добавьте сначала поезд!'
      return nil
    end
    train = train_
    puts 'Куда необходимо переместить поезд?'
    puts '1 - вперед'
    puts '2 - назад'
    n = gets.to_i
    case n
    when 1
      train.move_forward
    when 2
      train.move_back
    end
    puts 'Поезд перемещен!'
  end

  def train_by_number(number)
    raise 'Нет поезда с таким номером!' unless @trains.find { |train| train.number == number }

    @trains.find { |train| train.number == number }
  end

  def station_by_name(name)
    raise 'Нет станции с таким названием!' unless @stations.find { |station| station.name == name }

    @stations.find { |station| station.name == name }
  end

  def show_routes
    raise 'Нет маршрутов!' if @routes.empty?

    i = 1
    @routes.each do |route|
      puts "Маршрут №#{i}:"
      puts "\tСтанции в маршруте:"
      j = 1
      route.stations.each do |station|
        puts "\tСтанция №#{j} - #{station.name}"
        j += 1
      end
      i += 1
    end
  end

  def show_trains
    raise 'Нет поездов!' if @trains.empty?

    @trains.each do |train|
      type = if train.type == 'passenger'
               'пассажирский'
             else
               'грузовой'
             end
      puts "Поезд №#{train.number}, тип - #{type}"
    end
  end

  def show_trains_carriages
    begin
      show_trains
    rescue RuntimeError => e
      puts e.message
      puts 'Сначала добавьте поезд!'
      return nil
    end
    train = train_
    if train.type == 'cargo'
      train.each_carriage { |carriage| puts "#{carriage}, вместимость: #{carriage.volume}, свободно: #{carriage.free_volume}" }
    else
      train.each_carriage { |carriage| puts "#{carriage}, вместимость: #{carriage.capacity}, свободно: #{carriage.free_seats}" }
    end
    train
  end

  def fill_carriage
    train = show_trains_carriages
    return nil unless train

    if train.type == 'cargo'
      begin
        puts 'Введите номер вагона, в который надо добавить груз:'
        i = gets.to_i
        puts 'Введите объем груза:'
        volume = gets.to_i
        train.carriages[i - 1].put_load(volume)
      rescue RuntimeError => e
        puts e.message
        puts 'Недостаточно места в вагоне!'
        return nil
      end
      puts 'Успешно добавлено!'
    else
      begin
        puts 'Введите номер вагона, в который надо посадить пассажира:'
        i = gets.to_i
        carriage = train.carriages[i - 1]
        train.carriages[i - 1].take_seat
      rescue RuntimeError => e
        puts e.message
        puts 'Недостаточно места в вагоне!'
        return nil
      end
      puts 'Успешно добавлено!'
    end
  end

  def train_
    puts 'Введите номер поезда:'
    number = gets.chomp

    begin
      train = train_by_number(number)
    rescue RuntimeError => e
      puts e.message
      puts 'Введите номер поезда заново!'
      retry
    end
    train
  end
end
