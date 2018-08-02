class CargoWagon < Wagon
  attr_reader :volume, :reserved_volume

  def initialize(manufacturer, volume)
    super(manufacturer, :cargo)
    @volume = volume
    @reserved_volume = 0
  end

  def reserve_volume(amount)
    raise "Недостаточно места" if available_volume - amount < 0
    @reserved_volume += amount
  end

  def available_volume
    volume - reserved_volume
  end
end
