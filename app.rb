require "socket"

webserver = TCPServer.new(ENV['PORT'] || 8081)

responseTxt = <<-EOT
<!DOCTYPE html>
<html lang="en">
<head>
        <meta charset="utf-8">
        <title>Hello World</title>
</head>
 <body>
    <h4>Hello World!</h4>
</body>
</html>
EOT

while session = webserver.accept

    request = session.gets
    STDERR.puts request

    session.print "HTTP/1.1 200\r\n" +
        "Content-Type: text/html\r\n" +
        "Content-Length: #{responseTxt.bytesize}\r\n" +
        "\r\n"

    session.print responseTxt
    session.close

end
