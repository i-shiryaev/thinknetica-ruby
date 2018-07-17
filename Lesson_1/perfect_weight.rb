puts "Введите Ваше имя: "
name = gets.chomp
puts "Введите Ваш рост:"
height = gets.to_i
perfect_weight = height - 110

if perfect_weight < 0
  puts "Ваш вес уже оптимальный."
else
  puts "#{name}, Ваш идеальный вес: #{perfect_weight}"
end
