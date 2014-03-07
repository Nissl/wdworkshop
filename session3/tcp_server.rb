require 'socket'

server = TCPServer.open('localhost', 2000)

loop do
  client = server.accept
  puts "Receiving a request at #{Time.now}"
  client.puts "Hello World!"
  client.close
  sleep 1
  puts "Finished serving request at #{Time.now}"
end
