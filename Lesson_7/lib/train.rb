require_relative "validation.rb"

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  attr_reader :type, :speed, :route, :wagons, :number
  @@trains = {}
  NUMBER_FORMAT = /^[a-z0-9]{3}-*[a-z0-9]{2}$/i

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @wagons = []
    @@trains[number] = self
    validate!
    register_instance
  end

  def self.find(number)
    @@trains[number]
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

  # По аналогии с Array#each и Array#each_with_index.
  # По ТЗ задачи больше подходит первый, но для вывода списка второй удобнее.
  def each_wagon
    @wagons.each do |wagon|
      yield(wagon)
    end
  end

  def each_wagon_with_index
    @wagons.each.with_index(1) do |wagon, index|
      yield(index, wagon)
    end
  end

  protected

  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    route.stations[@current_station_index - 1] unless @current_station_index == 0
  end

  def next_station
    route.stations[@current_station_index + 1] unless @current_station_index == route.stations.size - 1
  end

  def validate!
    raise "Number's format should be correct." unless @number =~ NUMBER_FORMAT
  end
end
