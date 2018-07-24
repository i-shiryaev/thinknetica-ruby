require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'

class MainMenu
  def initialize
    @stations = []
    @trains = []
  end

  def show_menu
    choices_list("управление станциями", "управление поездами", true)
    input = gets.chomp

    loop do
      case input
      when "1"
        stations_menu
      when "2"
        trains_menu
      when "выход"
        exit
      else
        print "Введите другое значение: "
        input = gets.chomp
      end
    end
  end

  private

  def stations_menu
    puts "==="
    puts "Управление станциями:"
    choices_list("создание станции", "список станций", "перейти к управлению поездами", true)
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
      when "выход"
        exit
      else
        print "Введите другое значение: "
        input = gets.chomp
      end
    end
  end

  def trains_menu
    puts "==="
    puts "Управление поездами:"
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
        wagons_menu
      when "5"
        move_train_menu
      when "6"
        stations_and_trains
      when "выход"
        exit
      else
        print "Введите другое значение: "
        input = gets.chomp
      end
    end
  end

  def routes_menu
    if @trains.empty?
      puts "Вначале создайте поезд."
      create_train
    end
    if @stations.length < 2
      puts "Вначале создайте как минимум две станции."
      create_station
    end

    puts "Введите номер поезда из списка:"
    trains_list
    number = gets.chomp
    train = select_train(number)

    puts "Для составления маршрута доступны следующие станции:"
    stations_list
    puts "Вы хотите создать новую cтанцию или продолжить с текущими?"
    choices_list("создать новую станцию", "продолжить с текущими", false)
    input = gets.chomp
    loop do
      case input
      when "1"
        stations_menu
      when "2"
        create_route(train)
      when "выход"
        exit
      else
        print "Введите другое значение: "
        input = gets.chomp
      end
    end
  end

  def wagons_menu
    puts "Введите номер поезда из списка:"
    trains_list
    number = gets.chomp
    train = select_train(number)
    choices_list("добавить вагон", "отцепить вагон", "вернуться к управлению поездами")
    input = gets.chomp
    loop do
      case input
      when "1"
        wagon = create_wagon(train)
        train.add_wagon(wagon)
        trains_menu
      when "2"
        train.remove_wagon
        trains_menu
      when "3"
        trains_menu
      else
        print "Введите другое значение: "
        input = gets.chomp
      end
    end
  end

  def move_train_menu
    puts "Введите номер поезда из списка:"
    trains_list
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
        print "Введите другое значение: "
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
        blank_line
        puts "Станция #{name} успешно создана."
        break
      end
    end
    stations_menu
  end

  def station_exist?(name)
    existance = false
    @stations.each do |station|
      existance = true if station.name == name
    end
    existance
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
        blank_line
        puts "Поезд #{number} успешно создан."
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
        print "Введите другое значение: "
        input = gets.chomp
      end
    end
  end

  def train_exist?(number)
    existance = false
    @trains.each do |train|
      existance = true if train.number == number
    end
    existance
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

  def create_route(train)
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
        train.set_route(route)
        trains_menu
      else
        print "Введите другое значение: "
        input = gets.chomp
      end
    end
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

  def create_wagon(train)
    train.type == :cargo ? CargoWagon.new : PassengerWagon.new
  end
end
