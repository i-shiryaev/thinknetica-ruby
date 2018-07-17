input = []
3.times do
  puts "Введите коэффициент: "
  input << gets.chomp.to_f
end
a, b, c = input

if a == 0
  puts "Убедитесь, что переменная а не равна нулю и попробуйте снова."
  exit
end

d = b**2 - 4 * a * c

if d > 0
  d_root = Math.sqrt(d)
  x1 = (-b + d_root) / (2 * a)
  x2 = (-b - d_root) / (2 * a)
  puts "Дискриминант: #{d}. Корни: #{x1} и #{x2}."
elsif d == 0
  x = -b / (2 * a)
  puts "Дискриминант: #{d}. Корень: #{x}."
else
  puts "Корней нет."
end
