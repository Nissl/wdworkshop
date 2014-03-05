require 'rack'

def handle_request(headers)
  query_string = headers['QUERY_STRING']
  request_path = headers['REQUEST_PATH']
  body = File.open('hello.html').read
  [200, {'Content-Type' => 'text/html'}, [body]]
end

Rack::Handler::WEBrick.run method(:handle_request)
