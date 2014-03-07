require 'socket'

server = TCPServer.open('localhost', 2000)

while true
  client = server.accept
  request = client.gets
  puts "Getting request: #{request}"

  path = request.slice(/\/(.*) /).strip
  html = File.read("site#{path}")

  client.puts "HTTP/1.1 200 OK\r\nServer: Simple Ruby Server\r\nDate: #{Time.now}\r\nContent-Type: text/html\r\nContent-Length: #{html.length}\r\n\r\n#{html}"
  client.close
end
