fibonacci_array = [1, 1]
loop do
  next_element = fibonacci_array[-2] + fibonacci_array[-1]
  next_element < 100 ? fibonacci_array << next_element : break
end
puts fibonacci_array
