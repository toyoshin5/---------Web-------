require 'webrick'# Create a new WEBrick instance
  srv = WEBrick::HTTPServer.new({ :DocumentRoot => './',
    :BindAddress => '127.0.0.1',
    :Port => 2000,
    :CGIInterpreter => '/usr/bin/ruby'})
  srv.mount('/lab_search', WEBrick::HTTPServlet::CGIHandler, 'labSearch.rb')
  srv.mount('/member_search', WEBrick::HTTPServlet::CGIHandler, 'memberSearch.rb')
  trap("INT"){ srv.shutdown }
  puts "http://127.0.0.1:2000/lab_search?lab_name=hci-lab"
  puts "http://127.0.0.1:2000/lab_search?lab_name=hci-lab"
srv.start
