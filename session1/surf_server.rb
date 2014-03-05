require 'webrick'
require 'rack'

class SurfServer
  def call(env)
    local_file_name = "site#{env['PATH_INFO']}"
    if File.exists?(local_file_name)
      [200, {}, [File.open(local_file_name, "r").read]]
    else
      [404, {}, ["<html><body><h1> NOT FOUND </h1></body></html>"]]
    end
  end
end
