require "cgi"
require "sqlite3"
cgi = CGI.new
msg = "メッセージが見つかりませんでした"
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    member_name = cgi["member_name"]
    db = SQLite3::Database.new("data.db")
    lab_id = -1
    #1. メンバー名を入力して、ラボIDを取得する
    db.execute("SELECT lab_id FROM lab_members WHERE member_name = ?",[member_name]) do |row|
    lab_id = row[0]
    end
    if lab_id == -1
         #ラボが存在しない場合は、エラーを出力して終了する
        table = "メンバーが見つかりませんでした"
    else
        #2. ラボIDを使って、そのラボのメンバーを取得して、表にする。
        table = "<table border='1'>"
        table = table + "<tr><th>メンバー名</th></tr>"
        db.execute("SELECT member_name FROM lab_members WHERE (lab_id = ? and member_name != ?)",[lab_id],[member_name]) do |row|
            table = table + "<tr><td>#{row[0]}</td></tr>"
        end
        table = table + "</table>"
    end
    db.close
    html = "<html><body><h1>同じ研究室のメンバー一覧</h1>\n" 
    html = html + table
    html = html + "</body></html>"
    html
end