class PassengerWagon < Wagon
  def initialize(manufacturer, volume)
    super(manufacturer, :passenger, volume)
  end

  def reserve_space
    raise 'Бронь недоступна.' if available_space <= 0
    super(1)
  end
end
