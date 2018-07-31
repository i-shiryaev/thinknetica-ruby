module OutputHelper
  private

  MESSAGES = {
    blank_line: "",
    separator: "===",
    enter_another_value: "Введите другое значение:",
    stations_control: "Управление станциями:",
    trains_control: "Управление поездами:",
    create_train_first: "Вначале создайте поезд.",
    create_stations_first: "Вначале создайте как минимум две станции.",
    select_train_from_list: "Введите номер поезда из списка:",
    enter_manufacturer_name: "Введите название производителя:",
    enter_new_station_name: "Введите название новой станции:",
    station_already_exist: "Такая станция существует, введите другое значение:",
    stations_list: "Список станций:",
    trains_list: "Общий список поездов:",
    add_another_station: "Добавить станцию маршрута?",
    enter: "Введите:"
  }

  def message(key)
    puts MESSAGES[key]
  end

  def show_message(message)
    puts message
  end

  def user_input
    gets.chomp
  end

  def enter_another_value
    message :enter_another_value
    gets.chomp
  end

  def create_route_intro
    puts "Для составления маршрута доступны следующие станции:"
    stations_list
    puts "Вы хотите создать новую cтанцию или продолжить с текущими?"
    choices_list("создать новую станцию", "продолжить с текущими", false)
  end

  def train_created_successfully(number)
    message :blank_line
    puts "Поезд #{number} успешно создан."
  end

  def station_created_successfully(name)
    message :blank_line
    puts "Станция #{name} успешно создана."
  end

  def route_created_successfully(route)
    message :blank_line
    puts "Маршрут #{route.show_stations} успешно создан."
  end

  def enter_first_station
    print "Введите имя первой станции: "
    input = gets.chomp
  end

  def enter_last_station
    print "Введите имя последней станции: "
    input = gets.chomp
  end

  def enter_station_name
    print "Введите название станции: "
    input = gets.chomp
  end

  def show_manufacturers(manufacturers)
    puts manufacturers.join(", ")
  end

  def show_trains(numbers)
    puts numbers.join(", ")
  end

  def format_choices(number, option)
    puts "#{number} - #{option}"
  end

  def stations_and_trains_output(*args)
    station = args.first
    if args.size > 1
      trains = args.last
      show_message "Станция #{station.name}, поезда: #{trains.join(", ")}"
    else
      show_message "Станция #{station.name}"
    end
  end

  def wagon_created(manufacturer)
    message :blank_line
    puts "Вагон от производителя #{manufacturer} успешно создан."
  end

  def exit_message
    puts "выход - для выхода из приложения"
    print "> "
  end
end
