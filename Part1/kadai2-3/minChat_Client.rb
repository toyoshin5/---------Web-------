# coding: utf-8
require 'socket'
socket = TCPSocket.new('127.0.0.1', 2000) #127.0.0.1 の 2000 番ポートのサーバに接続

while true
    print 'Enter message : '
    msg = gets #標準入力から文字列を受け取る
    socket.puts msg #サーバに文字列を送信
    if msg.chomp == 'bye' #受け取った文字列が bye ならば
        break #ループを抜ける
    end
end
socket.close #サーバとの通信を切断