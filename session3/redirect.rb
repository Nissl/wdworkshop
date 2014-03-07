require 'socket'

server = TCPServer.open('localhost', 2000)

while true
  client = server.accept

  request = client.gets
  puts request
  path = request.slice(/\/(.*) /).strip

  if path == '/'
    response = "HTTP/1.1 302 FOUND\r\nServer: Simple Ruby Server\r\nDate: #{Time.now}\r\nLocation: /index.html"
    client.puts response
    puts "REDIRECT TO /index.html"
  elsif File.exists?("site#{path}")
    html = File.read("site#{path}")
    suffix = path.slice(/\.(.*)/)

    content_type = case suffix
                  when ".html" then 'text/html'
                  when ".css" then 'text/css'
                  when '.jpg' then 'image/jpeg'
                  end

    response = "HTTP/1.1 200 OK\r\nServer: Simple Ruby Server\r\nDate: #{Time.now}\r\nContent-Type: #{content_type}\r\nContent-Length: #{html.length}\r\n\r\n#{html}"
    client.puts response
    puts "sending #{path} file"
  else
    response = "HTTP/1.1 404 NOT FOUND\r\n\r\n <html><body><h1>Can't find the page you requested </h1></body></html>"
    client.puts response
    puts "sending #{path} file"
  end
  client.close
end
