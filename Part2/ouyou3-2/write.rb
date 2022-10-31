require "cgi"
require "sqlite3"
cgi = CGI.new
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    # パラメータ取得
    msg = cgi["msg"]
    user = cgi["user"]
    NG = ["NG"]
    if msg.length != 0 and user.length != 0 then 
        #NGワードが含まれていなかったら
        if NG.all?{|ng| msg.include?(ng) == false} then
            # #いまのファイルの末尾の行のid+1をidとする
            # id = 0
            # data = File.read('data.txt', encoding: 'UTF-8')
            # data = data.split("\n")
            # data.each do |line|
            #     line = line.split(",")
            #     id = line[0].to_i
            # end
            # id = id + 1
            # #userとmsgをdbに書き込む
            db = SQLite3::Database.new("bulletinBoard.db")
            db.execute("INSERT INTO messages(user,msg) VALUES (?,?)",[user,msg])
            db.close
            res = "#{user} がメッセージ: #{msg} を書き込みました" 
        else
            res = "NGワードが含まれています"
        end
    else
        res = "メッセージを書き込めませんでした。引数に誤りがある可能性があります。"
    end
    html = "<html><body>\n" 
    html = html + "<p>#{res}</p>"
    html = html + "</body></html>"
    html
end