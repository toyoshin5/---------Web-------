require "cgi"
require "sqlite3"
cgi = CGI.new
msg = "メッセージが見つかりませんでした"
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    # パラメータ取得
    id = cgi["id"]
    msg = "id:#{id} を削除しました"
    db = SQLite3::Database.new("bulletinBoard.db")
    # データベースからデータを削除して、成功したらmsgを設定する
    db.execute("DELETE FROM messages WHERE id = ?",[id])
    db.close
    html = "<html><body>\n" 
    html = html + "<p>#{msg}</p>"
    html = html + "</body></html>"
    html
end