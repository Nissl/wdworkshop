require 'socket'

server = TCPServer.open('localhost', 2000)

loop do
  client = server.accept
  client.puts "Hello World!"
  client.close
end
