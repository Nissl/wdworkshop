require 'webrick'

class SimpleServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    if request.path == '/' || request.path == '/hello.html'
      response.body = File.open('hello.html').read
    elsif request.path == '/hello2.html'
      response.body = File.open('hello2.html').read
    end
    response.status = 200
  end
end

server = WEBrick::HTTPServer.new(:Port => 1234)
server.mount "/", SimpleServlet
trap("INT") { server.shutdown }
server.start
