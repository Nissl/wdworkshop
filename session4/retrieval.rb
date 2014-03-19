require 'csv'

class SurfCarmel
  def initialize
    @journal_entries = read_journal_entries
  end

  def call(env)
    request = Rack::Request.new(env)
    if get('/', request)
      @data = {journal_entries: @journal_entries, water_conditions: read_water_conditions}
      render :index
    elsif post('/create_journal_entry', request)
      write_journal_entries(request.params)
      redirect_to '/'
    elsif get('/search_journal_entry', request)
      search_term = request.params["search_word"]
      found_entries = @journal_entries.select {|entry| entry[:title].include?(search_term) || entry[:description].include?(search_term)}
      @data = {journal_entries: found_entries }
      render :search_results
    elsif request.get? && request.path =~ /^\/journal_entries\/.*$/
      entry_id = (/^\/journal_entries\/(.*)$/.match(request.path))[1]
      selected_entry = @journal_entries.select {|entry| entry[:index] == entry_id}.first
      @data = {journal_entry: selected_entry}
      render :show
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
    result = entries.reduce([]) do |result, entry|
      result << {index: entry[0], title: entry[1], description: entry[2]}
    end
    result.sort_by {|hash| hash[:index]}.reverse
  end

  def write_journal_entries(entry)
    CSV.open("data/journal_entries.csv", "a") do |csv|
      csv << [journal_entry_count+1, entry['title'], entry['description']]
    end
    @journal_entries = nil
  end

  def journal_entry_count
    CSV.read("data/journal_entries.csv").count
  end

  def read_water_conditions
    conditions = CSV.read("data/water_conditions.csv")
    conditions.reduce([]) do |result, condition|
      result << {date: condition[0], description: condition[1]}
    end
  end
end
