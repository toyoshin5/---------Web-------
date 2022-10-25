require "cgi"
cgi = CGI.new
msg = "メッセージが見つかりませんでした"
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    # パラメータ取得
    id = cgi["id"]
    #idの行を削除する
    data = File.read('data.txt', encoding: 'UTF-8')
    file = File.open("data.txt","w", encoding: 'UTF-8')
    data = data.split("\n")
    data.each do |line|
        line = line.split(",")
        if line[0] != id
            file.puts("#{line[0]},#{line[1]}")
        else
            msg = "id:#{line[0]}<br>メッセージ:#{line[1]}<br>を削除しました"
        end
    end
    html = "<html><body>\n" 
    html = html + "<p>#{msg}</p>"
    html = html + "</body></html>"
    html
end