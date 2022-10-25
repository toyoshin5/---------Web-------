require "cgi"
cgi = CGI.new
cgi.out("type" => "text/html" ,
         "charset" => "UTF-8")  do
    # パラメータ取得
    num = cgi["num"].to_i
    html = "<head>
    <meta charset='UTF-8'>
    </head>
    <body>
    <h1>FizzBuzz</h1>
    <p>
    <table border='1'>
    <tr><th>整数</th><th>結果</th></tr>
        <script>
            for (var i = 1; i <= #{num}; i++) {
                document.write('<tr>');
                document.write('<td>' + i + '</td>');
                document.write('<td>');
                if (i % 15 == 0) {
                    document.write('FizzBuzz');
                } else if (i % 3 == 0) {
                    document.write('Fizz');
                } else if (i % 5 == 0) {
                    document.write('Buzz');
                } else {
                    document.write(i);
                }
                document.write('</td>');
                document.write('</tr>');
            }
        </script>
        </table>
    </body>

    </html>"
end
