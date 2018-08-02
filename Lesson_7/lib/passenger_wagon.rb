class PassengerWagon < Wagon
  attr_reader :seats_number, :reserved_seats

  def initialize(manufacturer, seats_number)
    super(manufacturer, :passenger)
    @seats_number = seats_number.to_i
    @reserved_seats = 0
  end

  def reserve_seat
    raise "Бронь недоступна" if available_seats <= 0
    @reserved_seats += 1
  end

  def available_seats
    seats_number - reserved_seats
  end
end
