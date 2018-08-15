require_relative 'validation.rb'
require_relative 'accessors.rb'

class Route
  include InstanceCounter
  include Validation
  extend Accessors
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
    register_instance
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
    # Так как стартовая и конечная точки маршрута не могут быть удалены.
    allowed_stations = stations.slice(1...-1)
    stations.delete(station) if allowed_stations.include?(station)
  end

  def show_stations
    station_names = []
    stations.each { |station| station_names << station.name }
    station_names.join(', ')
  end

  protected

  def validate!
    raise 'First station should be an object of Station.' unless first_station.is_a? Station
    raise 'Last station should be an object of Station.' unless last_station.is_a? Station
    raise 'First and last stations should be different.' if first_station == last_station
  end
end
