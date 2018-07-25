require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'


class MainMenu
  def initialize
    @stations = []
    @trains = []
    @wagons = []
    @routes = []
  end

  def show_menu
    choices_list("управление станциями", "управление поездами", "управление вагонами", "управление маршрутами", true)
    input = gets.chomp

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
        enter_another_value
        input = gets.chomp
      end
    end
  end

  private

  def stations_menu
    stations_menu_intro
    choices_list(
      "создание станции", "список станций", "перейти к управлению поездами",
      "вернуться в корневое меню", true
    )
    input = gets.chomp

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
        enter_another_value
        input = gets.chomp
      end
    end
  end

  def trains_menu
    trains_menu_intro
    choices_list(
      "создать новый поезд", "перейти к управлению станциями", "назначить маршрут поезду",
      "управление вагонами", "переместить поезд по маршруту", "открыть список станций и поездов",
      true
    )
    input = gets.chomp
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
        enter_another_value
        input = gets.chomp
      end
    end
  end

  # Для вызова из меню поездов
  def routes_menu
    if @trains.empty?
      puts "Вначале создайте поезд."
      create_train
    end
    if @stations.length < 2
      puts "Вначале создайте как минимум две станции."
      create_station
    end

    select_train_from_list_message
    number = gets.chomp
    train = select_train(number)

    create_route_intro
    input = gets.chomp
    loop do
      case input
      when "1"
        stations_menu
      when "2"
        create_route(train, true)
      when "выход"
        exit
      else
        enter_another_value
        input = gets.chomp
      end
    end
  end

  # Для вызова из корневого меню
  def create_route_menu
    create_route_intro
    input = gets.chomp
    loop do
      case input
      when "1"
        stations_menu
      when "2"
        create_route(false)
      when "выход"
        exit
      else
        enter_another_value
        input = gets.chomp
      end
    end
  end

  # Для вызова из корневого меню
  def wagons_menu
    choices_list("создать новый вагон", "посмотреть производителей вагонов", true)
    input = gets.chomp
    loop do
      case input
      when "1"
        create_wagon
      when "2"
        manufacturers_list
        break
      when "выход"
        exit
      else
        enter_another_value
        input = gets.chomp
      end
    end
  end

  # Для вызова из меню поездов
  def wagons_menu_for_train
    select_train_from_list_message
    number = gets.chomp
    train = select_train(number)
    choices_list("добавить вагон", "отцепить вагон", "вернуться к управлению поездами")
    input = gets.chomp
    loop do
      case input
      when "1"
        enter_manufacturer_name_message
        manufacturer = gets.chomp
        wagon = create_wagon_for_train(train, manufacturer)
        train.add_wagon(wagon)
        @wagons << wagon
        trains_menu
      when "2"
        enter_manufacturer_name_message
        manufacturer = gets.chomp
        train.remove_wagon(manufacturer)
        trains_menu
      when "3"
        trains_menu
      else
        enter_another_value
        input = gets.chomp
      end
    end
  end

  def move_train_menu
    select_train_from_list_message
    number = gets.chomp
    train = select_train(number)
    routes_menu if train.route.nil?
    choices_list(
      "отправить на следующую станцию", "отправить на предыдущую станцию",
      "вернуться к управлению поездами", true
    )
    input = gets.chomp
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
        enter_another_value
        input = gets.chomp
      end
    end
  end

  # Вспомогательные методы для станций:
  def create_station
    print "Введите название новой станции: "
    loop do
      name = gets.chomp
      if station_exist?(name)
        print "Такая станция существует, введите другое значение: "
      else
        @stations << Station.new(name)
          station_created_message
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
    blank_line
    puts names.join(", ")
  end

  def select_station(name)
    selected_stations = @stations.select { |station| station.name == name }
    if selected_stations.empty?
      puts "Введите правильное имя станции и повторите попытку."
      routes_menu
    else
      selected_stations.first
    end
  end

  def stations_and_trains
    create_station if @stations.empty?
    create_train if @trains.empty?
    puts "Список станций: "
    @stations.each do |station|
      if station.trains.length > 0
        trains = []
        station.trains.each do |train|
          trains << train.number
        end
        puts "Станция #{station.name}, поезда: #{trains.join(", ")}"
      else
        puts "Станция #{station.name}"
      end
    end
    puts "Общий список поездов:"
    trains_list
    trains_menu
  end

  # Вспомогательные методы для поездов:
  def create_train
    print "Введите номер нового поезда: "
    loop do
      number = gets.chomp
      if train_exist?(number)
        print "Такой номер существует, введите другое значение: "
      else
        create_train_by_type(number)
        train_created_message(number)
        break
      end
    end
    trains_menu
  end

  def create_train_by_type(number)
    choices_list("пассажирский поезд", "грузовой поезд", false)
    input = gets.chomp
    loop do
      case input
      when "1"
        @trains << PassengerTrain.new(number)
        break
      when "2"
        @trains << CargoTrain.new(number)
        break
      else
        enter_another_value
        input = gets.chomp
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
    puts numbers.join(", ")
  end

  def select_train(number)
    selected_trains = @trains.select { |train| train.number == number }
    if selected_trains.empty?
      puts "Введите правильный номер поезда и повторите попытку."
      routes_menu
    else
      selected_trains.first
    end
  end

  def create_route(*args)
    # Количество входящих данных будет различаться в зависимости от места видимости метода.
    # При вызова из корня меню объект train не передаётся.
    route_for_train = args.last
    print "Введите имя первой станции: "
    input = gets.chomp
    first_station = select_station(input)
    print "Введите имя второй станции: "
    input = gets.chomp
    second_station = select_station(input)
    route = Route.new(first_station, second_station)
    loop do
      puts "Добавить станцию маршрута?"
      choices_list("да", "нет", false)
      input = gets.chomp
      case input
      when "1"
        puts "Введите название станции: "
        input = gets.chomp
        station = select_station(input)
        route.add_station(station)
      when "2"
        if route_for_train
          train = args.first
          train.set_route(route)
          @routes << route
          trains_menu
        else
          @routes << route
          create_route_menu
        end
      else
        enter_another_value
        input = gets.chomp
      end
    end
  end

  # Вспомогательные методы для вагонов
  def create_wagon_for_train(train, manufacturer)
    train.type == :cargo ? CargoWagon.new(manufacturer) : PassengerWagon.new(manufacturer)
  end

  def create_wagon
    enter_manufacturer_name_message
    manufacturer = gets.chomp
    choices_list("создать пассажирский вагон", "создать грузовой вагон", false)
    input = gets.chomp
    loop do
      case input
      when "1"
        @wagons << PassengerWagon.new(manufacturer)
        wagons_menu
      when "2"
        @wagons << CargoWagon.new(manufacturer)
        wagons_menu
      else
        enter_another_value
        input = gets.chomp
      end
    end
  end

  def manufacturers_list
    manufacturers = []
    @wagons.each do |wagon|
      manufacturers << wagon.manufacturer
    end
    blank_line
    puts manufacturers.join(", ")
  end

  # Вспомогательные методы инпута и аутпута
  def enter_another_value
    print "Введите другое значение: "
  end

  def create_route_intro
    puts "Для составления маршрута доступны следующие станции:"
    stations_list
    puts "Вы хотите создать новую cтанцию или продолжить с текущими?"
    choices_list("создать новую станцию", "продолжить с текущими", false)
  end

  def stations_menu_intro
    puts "==="
    puts "Управление станциями:"
  end

  def trains_menu_intro
    puts "==="
    puts "Управление поездами:"
  end

  def enter_manufacturer_name_message
    puts "Введите название производителя: "
  end

  def select_train_from_list_message
    puts "Введите номер поезда из списка:"
    trains_list
  end

  def train_created_message(number)
    blank_line
    puts "Поезд #{number} успешно создан."
  end

  def station_created_message
    blank_line
    puts "Станция #{name} успешно создана."
  end

  # Прочие вспомогательные методы:
  def choices_list(*options, extra_lines)
    puts "Введите:"
    number = 1
    options.each do |option|
      puts "#{number} - #{option}"
      number += 1
    end
    if extra_lines
      puts "выход - для выхода из приложения"
      print "> "
    end
  end

  def blank_line
    # Отступ для читаемости вывода данных
    puts ""
  end
end
