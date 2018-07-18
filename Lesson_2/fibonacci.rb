fibonacci_array = [1]
next_element = 1
while next_element < 100
  fibonacci_array << next_element
  next_element = fibonacci_array[-2] + fibonacci_array[-1]
end
puts fibonacci_array
