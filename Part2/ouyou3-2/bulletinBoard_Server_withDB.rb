require 'webrick'# Create a new WEBrick instance
  srv = WEBrick::HTTPServer.new({ :DocumentRoot => './',
    :BindAddress => '127.0.0.1',
    :Port => 2000,
    :CGIInterpreter => '/usr/bin/ruby'})
  srv.mount('/write', WEBrick::HTTPServlet::CGIHandler,  'write.rb')
  srv.mount('/read', WEBrick::HTTPServlet::CGIHandler,   'read.rb')
  srv.mount('/index', WEBrick::HTTPServlet::CGIHandler,  'index.rb')
  srv.mount('/delete', WEBrick::HTTPServlet::CGIHandler, 'delete.rb')
  trap("INT"){ srv.shutdown }
srv.start
