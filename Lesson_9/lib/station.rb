require_relative 'validation.rb'
require_relative 'accessors.rb'

class Station
  include InstanceCounter
  include Validation
  extend Accessors
  attr_reader :trains, :name
  validate :name, String
  validate :name, :presence
  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    validate!
    register_instance
  end

  def self.all
    @@stations
  end

  def accept_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def select_trains(type)
    trains.select { |train| train.type == type }
  end

  def each_train
    @trains.each do |train|
      yield(train)
    end
  end
end
