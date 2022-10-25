require "cgi"
require "sqlite3"
cgi = CGI.new
msg = "メッセージが見つかりませんでした"
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    # パラメータ取得
    id = cgi["id"]
    # データベースを開く
    db = SQLite3::Database.new("bulletinBoard.db")
    # データベースからデータを取得する
    db.execute("SELECT user,msg FROM messages WHERE id = ?",[id]) do |row|
        msg = row[0] + "," + row[1]
    end
    db.close
    html = "<html><body>\n" 
    html = html + "<p>#{msg}</p>"
    html = html + "</body></html>"
    html
end