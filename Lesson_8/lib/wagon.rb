require_relative 'validation.rb'

class Wagon
  include Manufacturer
  include Validation
  attr_reader :type, :reserved_space

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

  protected

  def validate!
    raise 'Manufacturer should be a string.' unless @manufacturer.is_a? String
    raise 'Manufacturer should not be empty.' if @manufacturer.empty?
  end
end
