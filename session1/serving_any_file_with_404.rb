require 'webrick'

class SimpleServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    local_file = "site#{request.path}"
    if File.exists? local_file
      File.open(local_file, 'r') do |file|
        response.body = file.read
      end
      response.status = 200
    else
      response.body = "File does not exists."
      response.status = 404
    end
  end
end

server = WEBrick::HTTPServer.new(:Port => 1234)
server.mount "/", SimpleServlet
trap("INT") { server.shutdown }
server.start
