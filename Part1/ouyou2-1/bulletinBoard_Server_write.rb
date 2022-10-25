require "cgi"
cgi = CGI.new
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    # パラメータ取得
    msg = cgi["msg"]
    NG = [",","\r","\n","NG"]
    if msg.length != 0 then 
        #NGワードが含まれていなかったら
        if NG.all?{|ng| msg.include?(ng) == false} then
            #テキストファイルを開く
            file = File.open("data.txt","a", encoding: 'UTF-8')
            #いまのファイルの末尾の行のid+1をidとする
            id = 0
            data = File.read('data.txt', encoding: 'UTF-8')
            data = data.split("\n")
            data.each do |line|
                line = line.split(",")
                id = line[0].to_i
            end
            id = id + 1
            #ファイルにidとメッセージを追記する
            file.puts("#{id},#{msg}")
            res = "id:#{id}<br>メッセージ:#{msg}<br>を書き込みました" 
        else
            res = "NGワードが含まれています"
        end
    else
        res = "メッセージを書き込めませんでした"
    end
    html = "<html><body>\n" 
    html = html + "<p>#{res}</p>"
    html = html + "</body></html>"
    html
end