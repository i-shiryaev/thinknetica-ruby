class Train
  attr_reader :type, :speed, :route, :wagons, :number

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @wagons = []
  end

  def increase_speed(speed)
    @speed += speed if speed > 0
  end

  def decrease_speed(speed)
    @speed -= speed
    @speed = 0 if @speed - speed < 0
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if type == wagon.type
  end

  def remove_wagon(manufacturer)
    # Удаляет только из массива @wagons для поезда, но вагон продолжает жить
    # в массиве с аналогичном названием в MainMenu.
    @wagons.reject! { |wagon| wagon.manufacturer == manufacturer }
  end

  def set_route(route)
    @route = route
    @current_station_index = 0
    route.first_station.accept_train(self)
  end

  def move_to_next_station
    if next_station
      current_station.send_train(self)
      next_station.accept_train(self)
      @current_station_index += 1
    end
  end

  def move_to_previous_station
    if previous_station
      current_station.send_train(self)
      previous_station.accept_train(self)
      @current_station_index -= 1
    end
  end

  protected

=begin
  Так как три метода поиска станций не должны быть открыты для кода извне, вызываются
  только внутри методов объекта класса, и должны использоваться
  в наследуемых классах (CargoTrain, PassengerTrain) - отправляются в protected
=end
  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    route.stations[@current_station_index - 1] unless @current_station_index == 0
  end

  def next_station
    route.stations[@current_station_index + 1] unless @current_station_index == route.stations.size - 1
  end
end
