class CargoWagon < Wagon
  def initialize(manufacturer)
    super(manufacturer, :cargo)
  end
end
