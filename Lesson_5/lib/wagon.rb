class Wagon
  include Manufacturer
  attr_reader :type

  def initialize(manufacturer, type)
    @manufacturer = manufacturer
    @type = type
  end
end
