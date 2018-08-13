require_relative 'validation.rb'

class Wagon
  include Manufacturer
  include Validation
  attr_reader :type, :reserved_space
  validate :manufacturer, :presence
  validate :manufacturer, :type, String

  def initialize(manufacturer, type, volume)
    @manufacturer = manufacturer
    @type = type
    @volume = volume
    @reserved_space = 0
    validate!
  end

  def available_space
    @volume - reserved_space
  end

  def reserve_space(amount)
    @reserved_space += amount
  end
end
