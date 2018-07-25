class Wagon
  attr_reader :manufacturer, :type

  def initialize(manufacturer, type)
    @manufacturer = manufacturer
    @type = type
  end
end
