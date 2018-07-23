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
