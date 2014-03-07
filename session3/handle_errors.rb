require 'socket'

server = TCPServer.open('localhost', 2000)

while true
  client = server.accept
  url = client.gets.slice(/\/(.*) /).strip

  if File.exists?("site#{url}")
    html = File.read("site#{url}")
    suffix = url.slice(/\.(.*)/)

    content_type = case suffix
                  when ".html" then 'text/html'
                  when ".css" then 'text/css'
                  when '.jpg' then 'image/jpeg'
                  end

    client.puts "HTTP/1.1 200 OK\r\nServer: Simple Ruby Server\r\nDate: #{Time.now}\r\nContent-Type: #{content_type}\r\nContent-Length: #{html.length}\r\n\r\n#{html}"
  else
    client.puts "HTTP/1.1 404 NOT FOUND\r\n\r\n <html><body><h1>Can't find the page you requested </h1></body></html>"
  end
  client.close
end
