module Validation
  NUMBER_FORMAT = /^[a-z0-9]{3}-*[a-z0-9]{2}$/i

  def valid?
    begin
      validate!
      true
    rescue
      false
    end
  end

  protected

  def validate!
    if self.is_a? Train
      raise "Number's format should be correct." unless @number =~ NUMBER_FORMAT
    elsif self.is_a? Wagon
      raise "Manufacturer should not be empty." if @manufacturer.empty?
    elsif self.is_a? Station
      raise "Name should not be empty." if @name.empty?
    elsif self.is_a? Route
      raise "First station should be an object of Station." unless first_station.is_a? Station
      raise "Last station should be an object of Station." unless last_station.is_a? Station
    end
  end
end
