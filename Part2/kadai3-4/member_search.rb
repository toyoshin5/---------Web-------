# coding: utf-8
require 'sqlite3'
db = SQLite3::Database.new("data.db")
#print "名前を入力してください: "
member_name = gets.chomp
lab_id = -1
#1. メンバー名を入力して、ラボIDを取得する
db.execute("SELECT lab_id FROM lab_members WHERE member_name = ?",[member_name]) do |row|
  lab_id = row[0]
end
#メンバーが存在しない場合は、エラーを出力して終了する
if lab_id == -1
  puts "メンバーが見つかりませんでした"
  exit
end

#2.ラボIDを使って、そのラボのメンバーを取得する
db.execute("SELECT member_name FROM lab_members WHERE (lab_id = ? and member_name != ?)",[lab_id],[member_name]) do |row|
    puts row.join("\n")
  end
db.close
