class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def accept_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def select_trains(type)
    trains.select{ |train| train.type == type }
  end
end

class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    allowed_stations = stations.slice(1...-1) # Так как стартовая и конечная точки маршрута не могут быть удалены.
    stations.delete(station) if allowed_stations.include?(station)
  end

  def show_stations
    stations.each { |station| puts station.name }
  end
end

class Train
  attr_reader :type, :speed, :route, :carriages_amount

  def initialize(number, type, carriages_amount)
    @number = number
    @type = type
    @carriages_amount = carriages_amount
    @speed = 0
  end

  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    route.stations[@current_station_index - 1] unless @current_station_index == 0
  end

  def next_station
    route.stations[@current_station_index + 1] unless @current_station_index == route.stations.size - 1
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

  def add_carriage
    @carriages_amount += 1 if speed == 0
  end

  def remove_carriage
    @carriages_amount -= 1 if speed == 0 && carriages_amount > 0
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
end
