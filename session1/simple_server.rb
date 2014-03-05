require 'rack'
require 'pry'

def handle_request(headers)
  [200, {}, ["Time is #{Time.now}"]]
end

Rack::Handler::WEBrick.run method(:handle_request)
