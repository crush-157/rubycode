require "socket"
require 'net/http'
require 'sequel'
webserver = TCPServer.new(ENV['PORT'] || 8081)

url = URI.parse("http://ip.jsontest.com")
req = Net::HTTP::Get.new(url.to_s)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}
puts res.body

def db
  @db ||= Sequel.connect(
  'mysql2://' + ENV.fetch('MYSQLCS_CONNECT_STRING',
                          '127.0.0.1:3306/sample_db'),
    :user => ENV.fetch('MYSQLCS_USER_NAME','root'),
    :password => ENV.fetch('MYSQLCS_USER_PASSWORD','password')
  )
end

ds = db["SELECT * FROM SampleTable"]
ds.each {|r| puts "#{r} <br/>" }

responseTxt = <<-EOT
<!DOCTYPE html>
<html lang="en">
<head>
        <meta charset="utf-8">
        <title>Fighter running!</title>
</head>
 <body>
    <h4>Fighter running!</h4>
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
