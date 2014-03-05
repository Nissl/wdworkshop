require 'webrick'

class SimpleServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    response.status = 200
    response.body = File.open('hello.html').read
  end
end

server = WEBrick::HTTPServer.new(:Port => 1234)
server.mount "/", SimpleServlet
trap("INT") { server.shutdown }
server.start
