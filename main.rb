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
    puts '11 - выход из программы'
    puts 'Ваш ответ: '
    n = gets.to_i
  end

  def add_station
    puts 'Введите название станции: '
    name = gets.chomp
    @stations << Station.new(name)
    puts 'Станция добавлена!'
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
      station.trains.each do |train|
        puts "Поезд №#{train.number}"
      end
    end
  end

  def add_train
    puts 'Введите номер поезда:'
    train_number = gets.to_i
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
    puts 'Поезд добавлен!'
  end

  def add_route
    if @stations.count < 2
      puts 'Недостаточно станций для создания маршрута!'
      return nil
    else
      puts 'Введите название начальной станции:'
      first_station_name = gets.chomp
      puts 'Введите название конечной станции:'
      last_station_name = gets.chomp
      first_station = station_by_name(first_station_name)
      last_station = station_by_name(last_station_name)
      @routes << Route.new(first_station, last_station)
      puts 'Маршрут добавлен!'
    end

  end

  def add_station_for_route
    return if show_routes == '404'

    puts 'Выберите маршрут для редактирования:'
    route_number = gets.to_i
    route = @routes[route_number - 1]
    puts '1 - добавить станцию'
    puts '2 - удалить станцию'
    puts 'Ваш ответ: '
    n = gets.to_i

    puts 'Введите название станции: '
    station_name = gets.chomp
    station = station_by_name(station_name)
    case n
    when 1
      unless @stations.find(station).nil?
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
    return if show_trains == '404'

    puts 'Введите номер поезда, которому необходио назначить маршрут:'
    train_number = gets.to_i

    return if show_routes == '404'

    puts 'Введите номер маршрута, который необходимо назначить:'
    route_number = gets.to_i
    train = train_by_number(train_number)
    route = @routes[route_number - 1]
    train.route = route
    puts 'Маршрут назначен!'
  end

  def add_carriage
    return if show_trains == '404'

    puts 'Введите номер поезда, к которому необходимо прицепить вагон:'
    train_number = gets.to_i
    train = train_by_number(train_number)
    carriage = if train.type == 'passenger'
                 PassengerCarriage.new
               else
                 CargoCarriage.new
               end
    train.attach_carriage(carriage)
    puts 'Вагон прицеплен!'
  end

  def delete_carriage
    return if show_trains == '404'

    puts 'Введите номер поезда, от которого необходимо отцепить вагон:'
    train_number = gets.to_i
    train = train_by_number(train_number)
    unless train.carriages.count.positive?
      puts 'Вагонов нет!'
      return nil
    end
    train.detach_carriage
    puts 'Вагон отцеплен!'
  end

  def move_train
    return if show_trains == '404'

    puts 'Введите номер поезда, который необходимо переместить:'
    train_number = gets.to_i
    train = train_by_number(train_number)
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
    @trains.find { |train| train.number == number }
  end

  def station_by_name(name)
    @stations.find { |station| station.name == name }
  end

  def show_routes
    if @routes.empty?
      puts 'Нет маршрутов!'
      return '404'
    end
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
    if @trains.empty?
      puts 'Нет поездов!'
      return '404'
    end
    @trains.each do |train|
      type = if train.type == 'passenger'
               'пассажирский'
             else
               'грузовой'
             end
      puts "Поезд №#{train.number}, тип - #{type}"
    end
  end
end
