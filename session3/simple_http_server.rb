require 'socket'

server = TCPServer.open('localhost', 2000)
html = "<html><body><p>Hello World!</p></body></html>"

loop do
  client = server.accept
  client.puts "HTTP/1.1 200 OK\r\nServer: Simple Ruby Server\r\nDate: #{Time.now}\r\nContent-Type: text/html\r\n\r\n#{html}"
  client.close
end
