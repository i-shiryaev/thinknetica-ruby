def triangle_area(a, h)
  return 0.5 * a * h
end

puts "Введите основание треугольника: "
a = gets.chomp.to_f
puts "Введите высоту треугольника: "
h = gets.chomp.to_f

puts "Площадь треугольника #{triangle_area(a, h)}"
