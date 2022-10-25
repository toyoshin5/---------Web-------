require 'webrick'# Create a new WEBrick instance
  srv = WEBrick::HTTPServer.new({ :DocumentRoot => './',
    :BindAddress => '127.0.0.1',
    :Port => 2000})
  srv.mount('/form', WEBrick::HTTPServlet::FileHandler, 'login.html')
  srv.mount_proc("/login") do |req, res|
    x = req.query
    body = ""
    #list.txtを読み込みパスワードを比較
    File.open("list.txt") do |file|
      file.each_line do |line|
        if line.chomp == x["password"].chomp
          body = 
    "<html><body><head><meta charset='utf-8'></head>
    <p>OK</p></body></html>"
          break
        else
          body = 
          "<html><body><head><meta charset='utf-8'></head>
          <p>NG</p></body></html>"
        end
      end
    end
    # body = 
    # "<html><body><head><meta charset='utf-8'></head>
    # <p>こんにちは#{x["password"]}</p></body></html>"
    res.status = 200
    res['Content-Type'] = 'text/html'
    res.body = body
    end
  srv.start
  trap("INT"){ srv.shutdown }
srv.start
