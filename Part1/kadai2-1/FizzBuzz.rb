print "整数を入力してください:"
a = gets.to_i
#1からaまでfizzbuzz
puts "1から#{a}までのFizzBuzzを実行します"
for i in 1..a
    if i % 3 == 0 && i % 5 == 0
        puts "FizzBuzz"
    elsif i % 3 == 0
        puts "Fizz"
    elsif i % 5 == 0
        puts "Buzz"
    else
        puts i
    end
end
