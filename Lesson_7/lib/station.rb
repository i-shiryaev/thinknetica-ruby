require_relative "validation.rb"

class Station
  include InstanceCounter
  include Validation
  attr_reader :trains, :name
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
    trains.select{ |train| train.type == type }
  end

  def each_train
    @trains.each do |train|
      yield(train)
    end
  end

  def each_train_with_index
    index = 1
    @trains.each do |index, train|
      yield(train)
      index += 1
    end
  end

  private

  def validate!
    raise "Name should be a string." unless @name.is_a? String
    raise "Name should not be empty." if @name.empty?
  end
end
