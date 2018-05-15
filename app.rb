require 'sinatra'
require 'httpclient'
require 'sequel'

client = HTTPClient.new
p client.get("http://ip.jsontest.com").content

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

__END__
@@home
<!doctype html>
<html>
  <body>
  Fighter running!
  </body>
</html>
