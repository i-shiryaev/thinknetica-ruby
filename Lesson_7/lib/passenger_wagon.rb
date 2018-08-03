class PassengerWagon < Wagon
  def initialize(manufacturer, volume)
    super(manufacturer, :passenger, volume)
  end

  def reserve_space(volume)
    raise "Бронь недоступна." if available_space <= 0
    super(volume)
  end
end
