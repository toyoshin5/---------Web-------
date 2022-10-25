require 'webrick'# Create a new WEBrick instance
  srv = WEBrick::HTTPServer.new({ :DocumentRoot => './',
    :BindAddress => '127.0.0.1',
    :Port => 2000,
    :CGIInterpreter => '/usr/bin/ruby'})
  srv.mount('/time', WEBrick::HTTPServlet::FileHandler, 'time.html')
  srv.mount('/fizzbuzz', WEBrick::HTTPServlet::CGIHandler, 'reply_WebServer_Cgi.rb')
  trap("INT"){ srv.shutdown }
srv.start

