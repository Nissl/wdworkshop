require 'socket'
require 'pry'

server = TCPServer.open('localhost', 2000)
# html = File.read("site/index.html")
html = "<html></html>"

loop do
  client = server.accept
  client.puts "HTTP/1.1 200 OK\r\nServer: Simple Ruby Server\r\nDate: #{Time.now}\r\nContent-Type: text/html\r\nContent-Length: #{html.length}\r\n\r\n#{html}"
  client.close
end
