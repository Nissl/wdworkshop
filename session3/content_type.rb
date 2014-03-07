require 'socket'

server = TCPServer.open('localhost', 2000)

while true
  client = server.accept
  path = client.gets.slice(/\/(.*) /).strip
  html = File.read("site#{path}")

  suffix = path.slice(/\.(.*)/)
  content_type = case suffix
                 when ".html" then 'text/html'
                 when ".css" then 'text/css'
                 when '.jpg' then 'image/jpeg'
                 end

  client.puts "HTTP/1.1 200 OK\r\nServer: Simple Ruby Server\r\nDate: #{Time.now}\r\nContent-Type: #{content_type}\r\nContent-Length: #{html.length}\r\n\r\n#{html}"
  client.close
end
