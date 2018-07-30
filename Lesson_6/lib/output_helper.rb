module OutputHelper
  private

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

  def station_created_message(name)
    blank_line
    puts "Станция #{name} успешно создана."
  end

  def invalid_train_number
    puts "Введите корректный номер и повторите попытку."
    create_train
  end

  def invalid_train_selection
    puts "Введите правильный номер поезда и повторите попытку."
    routes_menu
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
    puts "Введите название станции: "
    input = gets.chomp
  end

  def invalid_station_name
    puts "Введите правильное имя станции и повторите попытку."
    routes_menu
  end

  def exit_message
    puts "выход - для выхода из приложения"
    print "> "
  end

  def blank_line
    # Отступ для читаемости вывода данных
    puts ""
  end
end
