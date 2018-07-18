cart = {}
final_price = 0
loop do
  puts "Введите название товара: "
  name = gets.chomp
  break if name == "стоп"
  puts "Введите цену за единицу товара: "
  price = gets.to_f
  puts "Введите количество купленного товара"
  amount = gets.to_f
  cart[name] = { price: price, amount: amount }
end

# Заполнить и вывести на экран хеш, ключами которого являются названия товаров,
# а значением - вложенный хеш, содержащий цену за единицу товара и кол-во купленного товара.
puts cart

# Также вывести итоговую сумму за каждый товар.
cart.each do |name, purchase|
  item_price = purchase[:price] * purchase[:amount]
  final_price += item_price
  puts "#{name}, стоимость: #{item_price}"
end

# Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
puts "Общая стоимость товаров: #{final_price}"
