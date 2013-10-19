namespace :run do
  task :greet do
    puts "Hello world"
  end

  task :gettweet => :environment do
    @tweet = USERHANDLE.user("ashishait") 
    @tweet = @tweet.to_json()
    # puts @tweet.class
    @hash = JSON.parse(@tweet)
    # parse turns json to hash object
    # puts @hash['status']['text']
    # puts @hash.class
    @hash.each_key().each do |key|
      puts "--> #{key} -> #{@hash[key]}"
    end
  end

  task :all => [:greet, :gettweet]  
  # You don't need to supply a block of code to all task

end

