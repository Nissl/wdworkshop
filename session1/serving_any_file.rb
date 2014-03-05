require 'webrick'

class SimpleServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    response.body = File.open("site#{request.path}").read
    response.status = 200
  end
end

server = WEBrick::HTTPServer.new(:Port => 1234)
server.mount "/", SimpleServlet
trap("INT") { server.shutdown }
server.start
