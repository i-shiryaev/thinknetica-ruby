class PassengerWagon < Wagon
  attr_reader :seats_number, :reserved_space
  alias :reserved_seats :reserved_space

  def initialize(manufacturer, seats_number)
    super(manufacturer, :passenger, seats_number)
  end

  def reserve_space
    raise "Бронь недоступна." if available_seats <= 0
    super(1)
  end

  def available_space
    super
  end

  alias_method :reserve_seat, :reserve_space
  alias_method :available_seats, :available_space
end
