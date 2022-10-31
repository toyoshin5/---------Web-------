require 'webrick'# Create a new WEBrick instance
require 'sqlite3'
  srv = WEBrick::HTTPServer.new({ :DocumentRoot => './',
    :BindAddress => '127.0.0.1',
    :Port => 2000})
  srv.mount('/form', WEBrick::HTTPServlet::FileHandler, 'login.html')
  srv.mount_proc("/login") do |req, res|
    x = req.query
    body = "NG"
    db = SQLite3::Database.new("password.db")
    #dbの中にあるuserとpassが一致するかどうかを調べる
    db.execute("select user,password from passwds") do |row|
      print row
      if row[0] == x["user"] && row[1] == x["password"]
        body = "OK"
        break
      end
    end
    res.status = 200
    res['Content-Type'] = 'text/html'
    res.body = body
    end
  srv.startZ
  trap("INT"){ srv.shutdown }
srv.start
