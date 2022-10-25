require "cgi"
require "sqlite3"
cgi = CGI.new
msg = "メッセージが見つかりませんでした"
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    #dbからnameとmsgを全て取得する
    res = ""
    db = SQLite3::Database.new("bulletinBoard.db")
    db.execute("SELECT user,id FROM messages") do |row|

        res = res + row[0] + ", " + "#{row[1]}" + "<br>"
    end
    db.close
    html = "<html><body>\n" 
    html = html + "<p>#{res}</p>"
    html = html + "</body></html>"
    html
end