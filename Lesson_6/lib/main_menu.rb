require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'
require_relative 'output_helper.rb'
require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'


class MainMenu
  include OutputHelper
  def initialize
    @stations = []
    @trains = []
    @wagons = []
    @routes = []
  end

  def show_menu
    choices_list("управление станциями", "управление поездами", "управление вагонами", "управление маршрутами", true)
    input = user_input

    loop do
      case input
      when "1"
        stations_menu
      when "2"
        trains_menu
      when "3"
        wagons_menu
      when "4"
        create_route_menu
      when "выход"
        exit
      else
        message :enter_another_value
        input = user_input
      end
    end
  end

  private

  def stations_menu
    message :separator
    message :stations_control
    choices_list(
      "создание станции", "список станций", "перейти к управлению поездами",
      "вернуться в корневое меню", true
    )
    input = user_input

    loop do
      case input
      when "1"
        create_station
      when "2"
        stations_list
        stations_menu
      when "3"
        trains_menu
      when "4"
        show_menu
      when "выход"
        exit
      else
        input = enter_another_value
      end
    end
  end

  def trains_menu
    message :separator
    message :trains_control
    choices_list(
      "создать новый поезд", "перейти к управлению станциями", "назначить маршрут поезду",
      "управление вагонами", "переместить поезд по маршруту", "открыть список станций и поездов",
      true
    )
    input = user_input
    loop do
      case input
      when "1"
        create_train
      when "2"
        stations_menu
      when "3"
        routes_menu
      when "4"
        wagons_menu_for_train
      when "5"
        move_train_menu
      when "6"
        stations_and_trains
      when "выход"
        exit
      else
        input = enter_another_value
      end
    end
  end

  # Для вызова из меню поездов
  def routes_menu
    if @trains.empty?
      message :create_train_first
      create_train
    end
    if @stations.length < 2
      message :create_stations_first
      create_station
    end
    message :select_train_from_list
    trains_list
    number = user_input
    train = select_train(number)

    create_route_intro
    input = user_input
    loop do
      case input
      when "1"
        stations_menu
      when "2"
        create_route(train, true)
      when "выход"
        exit
      else
        input = enter_another_value
      end
    end
  end

  # Для вызова из корневого меню
  def create_route_menu
    if @stations.length < 2
      message :create_stations_first
      stations_menu
    end
    create_route_intro
    input = user_input
    loop do
      case input
      when "1"
        stations_menu
      when "2"
        create_route(false)
      when "выход"
        exit
      else
        input = enter_another_value
      end
    end
  end

  # Для вызова из корневого меню
  def wagons_menu
    choices_list(
      "создать новый вагон", "посмотреть производителей вагонов",
      "вернуться в корневое меню", true
    )
    input = user_input
    loop do
      case input
      when "1"
        create_wagon_menu
      when "2"
        manufacturers_list
        break
      when "3"
        show_menu
      when "выход"
        exit
      else
        input = enter_another_value
      end
    end
  end

  # Для вызова из меню поездов
  def wagons_menu_for_train
    message :select_train_from_list
    trains_list
    train = select_train(user_input)
    choices_list("добавить вагон", "отцепить вагон", "вернуться к управлению поездами")
    input = user_input
    loop do
      case input
      when "1"
        message :enter_manufacturer_name
        manufacturer = user_input
        wagon = create_wagon_for_train(train, manufacturer)
        train.add_wagon(wagon)
        @wagons << wagon
        wagon_created(manufacturer)
        trains_menu
      when "2"
        message :enter_manufacturer_name
        manufacturer = user_input
        train.remove_wagon(manufacturer)
        trains_menu
      when "3"
        trains_menu
      else
        input = enter_another_value
      end
    end
  end

  def move_train_menu
    message :select_train_from_list
    number = user_input
    train = select_train(number)
    routes_menu if train.route.nil?
    choices_list(
      "отправить на следующую станцию", "отправить на предыдущую станцию",
      "вернуться к управлению поездами", true
    )
    input = user_input
    loop do
      case input
      when "1"
        train.move_to_next_station
        move_train_menu
      when "2"
        train.move_to_previous_station
        move_train_menu
      when "3"
        trains_menu
      when "выход"
        exit
      else
        input = enter_another_value
      end
    end
  end

  # Вспомогательные методы для станций:
  def create_station
    message :enter_new_station_name
    loop do
      name = user_input
      if station_exist?(name)
        message :station_already_exist
      else
        begin
          station = Station.new(name)
        rescue Exception => e
          show_message e.message
          create_station
        end
        @stations << station
          station_created_successfully(name)
        break
      end
    end
    stations_menu
  end

  def station_exist?(name)
    !!@stations.detect { |station| station.name == name }
  end

  def stations_list
    names = []
    @stations.each do |station|
      names << station.name
    end
    message :blank_line
    show_message names.join(", ")
  end

  def select_station(name)
    selected_stations = @stations.select { |station| station.name == name }
    if selected_stations.empty?
      enter_another_value
    else
      selected_stations.first
    end
  end

  def stations_and_trains
    create_station if @stations.empty?
    create_train if @trains.empty?
    message :blank_line
    message :stations_list
    @stations.each do |station|
      if station.trains.length > 0
        trains = []
        station.trains.each do |train|
          trains << train.number
        end
        stations_and_trains_output(station, trains)
      else
        stations_and_trains_output(station)
      end
    end
    message :trains_list
    trains_list
    trains_menu
  end

  # Вспомогательные методы для поездов:
  def create_train
    print "Введите номер нового поезда: "
    loop do
      number = user_input
      if train_exist?(number)
        print "Такой номер существует, введите другое значение: "
      else
        train = create_train_by_type(number)
        @trains << train
        train_created_successfully(number)
        break
      end
    end
    trains_menu
  end

  def create_train_by_type(number)
    choices_list("пассажирский поезд", "грузовой поезд", false)
    input = user_input
    loop do
      case input
      when "1"
        begin
          return PassengerTrain.new(number)
        rescue Exception => e
          show_message e.message
          create_train
        end
      when "2"
        begin
          return CargoTrain.new(number)
        rescue Exception => e
          show_message e.message
          create_train
        end
      else
        input = enter_another_value
      end
    end
  end

  def train_exist?(number)
    !!@trains.detect { |train| train.number == number }
  end

  def trains_list
    numbers = []
    @trains.each do |train|
      numbers << train.number
    end
    show_trains(numbers)
  end

  def select_train(number)
    selected_trains = @trains.select { |train| train.number == number }
    if selected_trains.empty?
      enter_another_value
    else
      selected_trains.first
    end
  end

  def create_route(*args)
    # Количество входящих данных будет различаться в зависимости от места видимости метода.
    # При вызова из корня меню объект train не передаётся.
    route_for_train = args.last
    first_station = select_station(enter_first_station)
    second_station = select_station(enter_last_station)
    begin
      route = Route.new(first_station, second_station)
    rescue Exception => e
      show_message e.message
      show_menu
    end
    loop do
      message :add_another_station
      choices_list("да", "нет", false)
      input = user_input
      case input
      when "1"
        station = select_station(enter_station_name)
        route.add_station(station)
      when "2"
        if route_for_train
          train = args.first
          train.set_route(route)
          @routes << route
          route_created_successfully(route)
          trains_menu
        else
          @routes << route
          route_created_successfully(route)
          show_menu
        end
      else
        input = enter_another_value
      end
    end
  end

  # Вспомогательные методы для вагонов
  def create_wagon_for_train(train, manufacturer)
    create_wagon(manufacturer, train.type)
  end

  def create_wagon(manufacturer, type)
    if type == :cargo
      begin
        CargoWagon.new(manufacturer)
      rescue Exception => e
        show_message e.message
        wagons_menu
      end
    else
      begin
        PassengerWagon.new(manufacturer)
      rescue Exception => e
        show_message e.message
        wagons_menu
      end
    end
  end

  def create_wagon_menu
    message :enter_manufacturer_name
    manufacturer = user_input
    choices_list("создать пассажирский вагон", "создать грузовой вагон", false)
    input = user_input
    loop do
      case input
      when "1"
        create_wagon(manufacturer, :passenger)
        wagon_created(manufacturer)
        wagons_menu
      when "2"
        create_wagon(manufacturer, :cargo)
        wagon_created(manufacturer)
        wagons_menu
      else
        input = enter_another_value
      end
    end
  end

  def manufacturers_list
    manufacturers = []
    @wagons.each do |wagon|
      manufacturers << wagon.manufacturer
    end
    message :blank_line
    show_manufacturers(manufacturers)
  end

  # Прочие вспомогательные методы:
  def choices_list(*options, extra_lines)
    message :enter
    number = 1
    options.each do |option|
      format_choices(number, option)
      number += 1
    end
    if extra_lines
      exit_message
    end
  end
end
