# coding: utf-8
require 'sqlite3'
db = SQLite3::Database.new("data.db")
#print "研究室名を入力してください: "
lab_name = gets.chomp
lab_id = -1
#1. ラボ名を入力して、ラボIDを取得する
db.execute("SELECT id FROM labs WHERE lab_name = ?",[lab_name]) do |row|
  lab_id = row[0]
end
#ラボが存在しない場合は、エラーを出力して終了する
if lab_id == -1
  puts "研究室が見つかりませんでした"
  exit
end
#2. ラボIDを使って、そのラボのメンバーを取得する
db.execute("SELECT member_name FROM lab_members WHERE lab_id = ?",[lab_id]) do |row|
    puts row.join("\n")
end
db.close
