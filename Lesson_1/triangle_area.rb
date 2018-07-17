def triangle_area(area, height)
  0.5 * area * height
end

puts "Введите основание треугольника: "
area = gets.chomp.to_f
puts "Введите высоту треугольника: "
height = gets.chomp.to_f

puts "Площадь треугольника #{triangle_area(area, height)}"
