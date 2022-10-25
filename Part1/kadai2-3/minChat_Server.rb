# coding: utf-8
require 'socket'
server = TCPServer.new 2000 #2000 番ポートにサーバを立てる
#クライアントの受付開始
client = server.accept #サーバのプログラムは，クライアントからのリクエストがあるまでここで一時停止(ブロッキングします)
while true
    msg = client.gets #クライアントから受信した文字列を表示
    puts msg
    if msg.chomp == 'bye' #受け取った文字列が bye ならば
        break #ループを抜ける
    end
end
client.close #クライアントとの通信を切断