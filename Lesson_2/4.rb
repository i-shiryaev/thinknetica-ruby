vowels_hash = {}
counter = 1
("a".."z").each do |letter|
  vowels_hash[letter] = counter if ['a','e','i','o','u'].include?(letter)
  counter +=1
end
puts vowels_hash
