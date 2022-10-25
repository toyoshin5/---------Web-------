require "cgi"
require "sqlite3"
cgi = CGI.new
msg = "メッセージが見つかりませんでした"
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    lab_name = cgi["lab_name"]

    db = SQLite3::Database.new("data.db")
    lab_id = -1
    #1. ラボ名を入力して、ラボIDを取得する
    db.execute("SELECT id FROM labs WHERE lab_name = ?",[lab_name]) do |row|
    lab_id = row[0]
    end
    if lab_id == -1
         #ラボが存在しない場合は、エラーを出力して終了する
        table = "研究室が見つかりませんでした"
    else
        #2. ラボIDを使って、そのラボのメンバーを取得して、表にする。
        table = "<table border='1'>"
        table = table + "<tr><th>研究室名</th><th>メンバー名</th></tr>"
        db.execute("SELECT member_name FROM lab_members WHERE lab_id = ?",lab_id) do |row|
            table = table + "<tr><td>#{lab_name}</td><td>#{row[0]}</td></tr>"
        end
        table = table + "</table>"
    end
    db.close
    html = "<html><body><h1>研究室のメンバー一覧</h1>\n" 
    html = html + table
    html = html + "</body></html>"
    html
end