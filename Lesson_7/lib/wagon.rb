require_relative "validation.rb"

class Wagon
  include Manufacturer
  include Validation
  attr_reader :type

  def initialize(manufacturer, type)
    @manufacturer = manufacturer
    @type = type
    validate!
  end

  protected

  def validate!
    raise "Manufacturer should be a string." unless @manufacturer.is_a? String
    raise "Manufacturer should not be empty." if @manufacturer.empty?
  end
end
