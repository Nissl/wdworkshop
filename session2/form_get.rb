class SurfCarmel
  def initialize
    @journal_entries = initial_journal_entries
    @water_conditions = initial_water_conditions
  end

  def call(env)
    request = Rack::Request.new(env)
    if request.get? && request.path == '/'
      new_entry_title = request.params["new_entry_title"]
      new_entry_description = request.params["new_entry_description"]
      template = File.read("templates/index.mustache")
      updated_journal_entries = @journal_entries.unshift({title: new_entry_title, description: new_entry_description})
      content = Mustache.render(template, {journal_entries: updated_journal_entries, water_conditions: @water_conditions})
      [200, {}, [content]]
    elsif request.get? && request.path == '/create_journal_entry'
      template = File.read("templates/index.mustache")
      updated_journal_entries = @journal_entries.unshift({title: new_entry_title, description: new_entry_description})
      content = Mustache.render(template, {journal_entries: updated_journal_entries, water_conditions: @water_conditions})
      [200, {}, [content]]
    else
      local_file = "site#{env['REQUEST_PATH']}"
      if File.exists? local_file
        File.open(local_file, 'r') do |file|
          [200, {},  [file.read]]
        end
      else
        [404, {}, ["File does not exist."]]
      end
    end
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
