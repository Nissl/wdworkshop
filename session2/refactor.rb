class SurfCarmel
  def initialize
    @journal_entries = initial_journal_entries
    @water_conditions = initial_water_conditions
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

  def initial_journal_entries
    [{title: 'A Look Back: "Huge Waves!"',
      description: <<-DESCRIPTION
      "Today's waves are record setting! 10 foot waves coming from the south and heading to the north. Hide your kids, hide your wife. Don't come out without your board!" A write up about the record setting day of surfing that went down in the history books. Don't miss this recount of the biggest surfing day in Carmel, CA.
      DESCRIPTION
    },{title: 'Feature Article: Johnny Smith',
       description: <<-DESCRIPTION
       Listen to local professional surfer, Johnny Smith, talk about the ups and downs of having a career in professional surfing. Johnny shares insight into his surfing philosophy, how he ended up where he is, and where he's planning on going.
       DESCRIPTION
    },{title: 'Tips: How to Catch the Waves You Want',
       description: <<-DESCRIPTION
       Local surfing instructor shares his secrets to watching the ocean and catching the waves that are worth your effort. Being choosy is an advantage with this strategy and will ensure a fun and fulfilling day of surfing.
       DESCRIPTION
    },{title: 'Feature Article: Attacked by a Shark and Still Surfing',
       description: <<-DESCRIPTION
       Our own hometown hero shares the terrifying story about a nearly fatal shark attack that took an arm but only fanned the fire of passion for a surfer's craft. This article shows us that even in the face of adversity, there is much to live for and much to achieve.
       DESCRIPTION
    }]
  end

  def initial_water_conditions
    [{date: 'February 19, 2014',
      description: 'Water temperature is estimated to be between 70-80 degrees fahrenheit, and the average wave height is going to be 4.5 feet. The best surfing time is going to be 8-10am in the morning. It will be a little cold at that time though, around 45 F, so be prepared!'
    },{date: 'February 20, 2014',
       description: 'Water temperature is estimated to be between 70-80 degrees fahrenheit, and the average wave height is going to be 4.5 feet. The best surfing time is going to be 8-10am in the morning. It will be a little cold at that time though, around 45 F, so be prepared!'
    }]
  end
end
