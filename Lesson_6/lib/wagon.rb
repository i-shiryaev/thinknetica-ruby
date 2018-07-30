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
end
