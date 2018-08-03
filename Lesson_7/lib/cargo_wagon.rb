class CargoWagon < Wagon
  attr_reader :volume, :reserved_space
  alias :reserved_volume :reserved_space

  def initialize(manufacturer, volume)
    super(manufacturer, :cargo, volume)
  end

  def reserve_space(amount)
    raise "Недостаточно места." if available_space - amount < 0
    super(amount)
  end

  def available_space
    super
  end

  alias_method :reserve_volume, :reserve_space
  alias_method :available_volume, :available_space
end
