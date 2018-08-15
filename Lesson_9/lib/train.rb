require_relative 'validation.rb'
require_relative 'accessors.rb'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  extend Accessors
  NUMBER_FORMAT = /^[a-z0-9]{3}-*[a-z0-9]{2}$/i

  attr_reader :type, :speed, :route, :wagons, :number
  attr_accessor_with_history :driver
  strong_attr_accessor :speed_limit, Integer
  validate :number, :format, NUMBER_FORMAT
  @@trains = {}

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
    @wagons.reject! { |wagon| wagon.manufacturer == manufacturer }
  end

  def add_route(route)
    @route = route
    @current_station_index = 0
    route.first_station.accept_train(self)
  end

  def move_to_next_station
    return false unless next_station
    current_station.send_train(self)
    next_station.accept_train(self)
    @current_station_index += 1
  end

  def move_to_previous_station
    return false unless previous_station
    current_station.send_train(self)
    previous_station.accept_train(self)
    @current_station_index -= 1
  end

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
    return false if @current_station_index.zero?
    route.stations[@current_station_index - 1]
  end

  def next_station
    return false if @current_station_index == route.stations.size - 1
    route.stations[@current_station_index + 1]
  end
end
