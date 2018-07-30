require_relative "lib/main_menu.rb"

train = CargoTrain.new("a1C-1a")
wagon = CargoWagon.new("11")
station = Station.new("1S")

puts station.valid?

=begin
print "Введите имя первой станции: "
input = gets.chomp
first_station = select_station(input)
print "Введите имя последней станции: "
input = gets.chomp
second_station = select_station(input)
=end
