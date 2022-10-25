require "cgi"
cgi = CGI.new
msg = "メッセージが見つかりませんでした"
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    # パラメータ取得
    id = cgi["id"]
    #テキストファイルを読み込む
    data = File.read('data.txt', encoding: 'UTF-8')
    #行と列の配列にする
    data = data.split("\n")
    data.each do |line|
        line = line.split(",")
        if line[0] == id
            msg = line[1]
        end
    end
    html = "<html><body>\n" 
    html = html + "<p>メッセージ:#{msg}</p>"
    html = html + "</body></html>"
    html
end