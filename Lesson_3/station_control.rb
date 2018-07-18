class Station
  attr_reader :trains

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
  attr_reader :stations, :first_station, :last_station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [first_station, last_station]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    allowed_stations = stations.slice(1...-1) # Так как стартовая и конечная точки маршрута не могут быть удалены.
    stations.delete(station) if allowed_stations.include?(station)
  end
end

class Train
  attr_accessor :speed, :carriages_amount, :current_station, :previous_station, :next_station, :route
  attr_reader :type

  def initialize(number, type, carriages_amount)
    @number = number
    @type = type
    @carriages_amount = carriages_amount
  end

  def stop
    self.speed = 0
  end

  def add_carriage
    self.carriages_amount += 1 if speed == 0
  end

  def remove_carriage
    self.carriages_amount -= 1 if speed == 0 && carriages_amount > 0
  end

  def set_route(route)
    @route = route
    @current_station = route.first_station
    set_stations(current_station)
  end

  def move_to_next_station
    unless next_station.nil?
      self.current_station = next_station
      set_stations(current_station)
    end
  end

  def move_to_previous_station
    unless previous_station.nil?
      self.current_station = previous_station
      set_stations(current_station)
    end
  end

  def set_stations(current_station)
    station_index = route.stations.index(current_station)
    @previous_station = route.stations[station_index - 1] unless station_index == 0
    @next_station = route.stations[station_index + 1] unless station_index == route.stations.size - 1
  end
end
