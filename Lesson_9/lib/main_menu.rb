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
    choices_list(:root_menu)
    loop do
      show_menu_select(user_input)
    end
  end

  private

  def show_menu_select(input)
    case input
    when '1' then stations_menu
    when '2' then trains_menu
    when '3' then wagons_menu
    when '4' then create_route_menu
    when 'выход' then exit
    else message :enter_another_value
    end
  end

  def stations_menu
    message :separator
    message :stations_control
    choices_list(:stations_menu)
    loop do
      stations_menu_select(user_input)
    end
  end

  def stations_menu_select(input)
    case input
    when '1' then create_station_submenu
    when '2'
      stations_list
      stations_menu
    when '3' then trains_menu
    when '4'then show_menu
    when 'выход' then exit
    else message :enter_another_value
    end
  end

  def trains_menu
    message :separator
    message :trains_control
    choices_list(:trains_menu)
    loop do
      trains_menu_select(user_input)
    end
  end

  def trains_menu_select(input)
    case input
    when '1' then create_train
    when '2' then stations_menu
    when '3' then routes_menu
    when '4' then train_wagons_menu
    when '5' then move_train_menu
    when '6'
      stations_and_trains_list
      trains_menu
    when 'выход' then exit
    else message :enter_another_value
    end
  end

  # Для вызова из меню поездов
  def routes_menu
    check_trains
    check_stations
    message :select_train_from_list
    trains_list
    train = select_train(user_input)
    create_route_intro
    loop do
      routes_menu_select(user_input, train)
    end
  end

  def routes_menu_select(input, train)
    case input
    when '1' then stations_menu
    when '2' then form_route(train, true)
    when 'выход' then exit
    else message :enter_another_value
    end
  end

  def check_trains
    return false unless @trains.empty?
    message :create_train_first
    create_train
  end

  def check_stations
    return false unless @stations.length < 2
    message :create_stations_first
    create_station_submenu
  end

  def check_wagons(train)
    return false unless train.wagons.empty?
    message :create_wagon_first
    train_wagons_menu
  end

  def check_route(train)
    return false if train.route
    message :create_route_first
    trains_menu
  end

  # Для вызова из корневого меню
  def create_route_menu
    check_stations
    create_route_intro
    loop do
      create_route_menu_select(user_input)
    end
  end

  def create_route_menu_select(input)
    case input
    when '1' then stations_menu
    when '2' then form_route(false)
    when 'выход' then exit
    else message :enter_another_value
    end
  end

  # Для вызова из корневого меню
  def wagons_menu
    choices_list(:wagons_menu)
    loop do
      wagons_menu_select(user_input)
    end
  end

  def wagons_menu_select(input)
    case input
    when '1' then create_wagon_menu
    when '2'
      manufacturers_list
      wagons_menu
    when '3' then show_menu
    when 'выход' then exit
    else message :enter_another_value
    end
  end

  # Для вызова из меню поездов
  def train_wagons_menu
    check_trains
    message :select_train_from_list
    trains_list
    train = select_train(user_input)
    choices_list(:manage_wagons)
    loop do
      train_wagons_menu_select(user_input, train)
    end
  end

  def train_wagons_menu_select(input, train)
    case input
    when '1' then create_and_add_wagon(train)
    when '2' then remove_wagon
    when '3'
      check_wagons(train)
      wagons_list(train)
      trains_menu
    when '4' then manage_wagons_menu(train)
    when '5' then trains_menu
    else message :enter_another_value
    end
  end

  def create_and_add_wagon(train)
    message :enter_manufacturer_name
    wagon = create_wagon(user_input, train.type)
    train.add_wagon(wagon)
    @wagons << wagon
    wagon_created(wagon)
    trains_menu
  end

  def remove_wagon
    message :enter_manufacturer_name
    train.remove_wagon(user_input)
    trains_menu
  end

  def move_train_menu
    check_trains
    message :select_train_from_list
    trains_list
    train = select_train(user_input)
    check_route(train)
    choices_list(:move_train)
    loop do
      move_train_menu_select(train, user_input)
    end
  end

  def move_train_menu_select(train, input)
    case input
    when '1'
      train.move_to_next_station
      trains_menu
    when '2'
      train.move_to_previous_station
      trains_menu
    when '3' then trains_menu
    when 'выход' then exit
    else message :enter_another_value
    end
  end

  # Вспомогательные методы для станций:
  def create_station_submenu
    message :enter_new_station_name
    name = user_input
    if station_exist?(name)
      message :station_already_exist
      stations_menu
    end
    station = create_station(name)
    @stations << station
    station_created_successfully(station.name)
    stations_menu
  end

  def create_station(name)
    Station.new(name)
  rescue StandardError => e
    show_message e.message
    name = user_input
    retry
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
    message :stations_list
    show_message names.join(', ')
  end

  def select_station(name)
    @stations.detect { |station| station.name == name }
  end

  # Вспомогательные методы для поездов:
  def create_train
    message :enter_new_number
    number = user_input
    while train_exist?(number)
      message :number_already_exist
      number = user_input
    end
    create_train_by_type(number)
  end

  def create_train_by_type(number)
    choices_list(:train_type)
    loop do
      create_train_by_type_select(user_input, number)
    end
  end

  def create_train_by_type_select(input, number)
    case input
    when '1'
      train = create_passenger_train(number)
      add_train(train)
    when '2'
      train = create_cargo_train(number)
      add_train(train)
    else message :enter_another_value
    end
  end

  def add_train(train)
    @trains << train
    train_created_successfully(train.number)
    trains_menu
  end

  def create_cargo_train(number)
    CargoTrain.new(number)
  rescue StandardError => e
    show_message e.message
    message :enter_another_value
    number = user_input
    retry
  end

  def create_passenger_train(number)
    PassengerTrain.new(number)
  rescue StandardError => e
    show_message e.message
    message :enter_another_value
    number = user_input
    retry
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
    selected_train = @trains.detect { |train| train.number == number }
    if selected_train.nil?
      message :train_doesnt_exist
      trains_menu
    else
      selected_train
    end
  end

  def form_route(*args)
    # Количество входящих данных будет различаться в зависимости от места видимости метода.
    # При вызова из корня меню объект train не передаётся.
    first_station = select_station(enter_first_station)
    last_station = select_station(enter_last_station)
    route = create_route(first_station, last_station)
    loop do
      message :add_another_station
      choices_list(:yes_or_no)
      form_route_select(user_input, route, args)
    end
  end

  def form_route_select(input, route, args)
    route_for_train = args.last
    case input
    when '1'
      add_station_to_route(route)
    when '2'
      if route_for_train
        add_route_for_train(args.first, route)
      else
        add_route(route)
      end
    else message :enter_another_value
    end
  end

  def add_station_to_route(route)
    station = select_station(enter_station_name)
    unless station
      message :station_doesnt_exist
      trains_menu
    end
    route.add_station(station)
  end

  def add_route_for_train(train, route)
    train.add_route(route)
    @routes << route
    route_created_successfully(route)
    trains_menu
  end

  def add_route(route)
    @routes << route
    route_created_successfully(route)
    show_menu
  end

  def create_route(first_station, last_station)
    Route.new(first_station, last_station)
  rescue StandardError => e
    show_message e.message
    show_menu
  end

  def create_wagon(manufacturer, type)
    if type == :cargo
      message :enter_wagon_volume
      volume = user_input.to_i
      create_cargo_wagon(manufacturer, volume)
    else
      message :enter_wagon_seats
      seats = user_input.to_i
      create_passenger_wagon(manufacturer, seats)
    end
  end

  def create_cargo_wagon(manufacturer, volume)
    CargoWagon.new(manufacturer, volume)
  rescue StandardError => e
    show_message e.message
    message :enter_manufacturer_name
    manufacturer = user_input
    message :enter_wagon_volume
    volume = user_input.to_i
    retry
  end

  def create_passenger_wagon(manufacturer, seats)
    PassengerWagon.new(manufacturer, seats)
  rescue StandardError => e
    show_message e.message
    message :enter_manufacturer_name
    manufacturer = user_input
    message :enter_wagon_seats
    seats = user_input.to_i
    retry
  end

  def create_wagon_menu
    message :enter_manufacturer_name
    choices_list(:wagon_type)
    loop do
      create_wagon_menu_select(user_input)
    end
  end

  def create_wagon_menu_select(manufacturer)
    case input
    when '1'
      wagon = create_wagon(manufacturer, :passenger)
      @wagons << wagon
      wagon_created(wagon)
      wagons_menu
    when '2'
      wagon = create_wagon(manufacturer, :cargo)
      @wagons << wagon
      wagon_created(wagon)
      wagons_menu
    else message :enter_another_value
    end
  end

  def manage_wagons_menu(train)
    wagons = train.wagons
    check_wagons(train)
    wagons_list(train)
    message :enter_manufacturer_name
    wagon = select_wagon(user_input, wagons)
    unless wagon
      message :manufacturer_doesnt_exist
      train_wagons_menu
    end
    manage_wagon(wagon)
  end

  def select_wagon(manufacturer, wagons)
    wagons.detect { |wagon| wagon.manufacturer == manufacturer }
  end

  def manage_wagon(wagon)
    wagon_info(wagon)
    choices_list(:reserve_space)
    loop do
      wagon_info_select(user_input, wagon)
    end
  end

  def wagon_info_select(input, wagon)
    case input
    when '1'
      reserve_wagon_space(wagon)
      message wagon.type == :cargo ? :volume_successfully_taken : :seat_successfully_taken
      trains_menu
    when '2'
      trains_menu
    else message :enter_another_value
    end
  end

  def reserve_wagon_space(wagon)
    wagon.type == :cargo ? wagon.reserve_space(enter_wagon_volume) : wagon.reserve_space
  rescue StandardError => e
    show_message e.message
    trains_menu
  end
end
