class SurfServer
  def call(env)
    local_file_name = "site#{env['PATH_INFO']}"
    if File.exists?(local_file_name)
      [200, {}, [File.read(local_file_name)]]
    else
      [404, {}, ["<html><body><h1> Can't find the page you requested </h1></body></html>"]]
    end
  end
end
