require "cgi"
cgi = CGI.new
msg = "メッセージが見つかりませんでした"
cgi.out("type" => "text/html","charset" => "UTF-8")  do
    #テキストファイルを読み込む
    data = File.read('data.txt', encoding: 'UTF-8')
    #idとメッセージの配列にする
    data = data.split("\n")
    
    html = "<html><body>\n" 
    data.each do |line|
        line = line.split(",")
        html = html + "<p>id:#{line[0]}</p>"
    end
    html = html + "</body></html>"
    html
end