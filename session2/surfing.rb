module Surfing
  def get(path, request)
    request.get? && request.path == path
  end

  def post(path, request)
    request.post? && request.path == path
  end

  def serve_static_file(env)
    local_file = "site#{env['REQUEST_PATH']}"
    if File.exists? local_file
      File.open(local_file, 'r') do |file|
        [200, {},  [file.read]]
      end
    else
      [404, {}, ["File does not exist."]]
    end
  end

  def render(template)
    template_content = File.read("templates/#{template.to_s}.mustache")
    document = Mustache.render(template_content, @data)
    [200, {}, [document]]
  end

  def redirect_to(path)
    [302, {"Location" => path}, []]
  end
end
