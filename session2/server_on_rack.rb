class SurfCarmel
  def call(env)
    local_file = "site#{env['REQUEST_PATH']}"
    if File.exists? local_file
      File.open(local_file, 'r') do |file|
        return [200, {},  [file.read]]
      end
    else
      [404, {}, ["File does not exist."]]
    end
  end
end
