require 'csv'

class SurfCarmel
  def initialize
    @journal_entries = read_journal_entries
    @water_conditions = read_water_conditions
  end

  def call(env)
    request = Rack::Request.new(env)
    if get('/', request)
      @data = {journal_entries: @journal_entries, water_conditions: @water_conditions}
      render :index
    elsif post('/create_journal_entry', request)
      @journal_entries.unshift(request.params)
      redirect_to '/'
    else
      serve_static_file(env)
    end
  end

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

  def read_journal_entries
    entries = CSV.read("data/journal_entries.csv")
    entries.reduce([]) do |result, entry|
      result << {title: entry[0], description: entry[1]} 
    end
  end

  def write_journal_entries
    
  end

  def read_water_conditions
    conditions = CSV.read("data/water_conditions.csv")
    conditions.reduce([]) do |result, condition|
      result << {date: condition[0], description: condition[1]}
    end
  end
end
