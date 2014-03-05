require 'rack'

rack_proc = Proc.new do |env|
  local_file = "site#{env['REQUEST_PATH']}"
  if File.exists? local_file
    File.open(local_file, 'r') do |file|
      file.
      return [200, {},  [file.read]]
    end
  else
    [404, {}, ["File does not exist."]]
  end
end

Rack::Handler::WEBrick.run rack_proc
