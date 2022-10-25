require 'matrix'
#正方行列を入力して2次元配列に保存
def input_matrix
    print "行列のサイズを入力:"
    size = gets.to_i
    matrix = Array.new(size){Array.new(size)}
    print "#{size}×#{size}の行列の要素を入力(数字ごとに改行):"
    size.times do |i|#行
        size.times do |j|#列
        matrix[i][j] = gets.to_i
        end
    end
    return matrix
end

m = input_matrix
#行列式の値を表示
puts "行列式の値は#{Matrix[*m].determinant}"

