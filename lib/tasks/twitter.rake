namespace :run do
  desc "Greets on terminal hello world"
  task :greet do
    puts "Hello world"
  end
  
  desc "gets info for a user"
  task :getuserinfo => :environment do
    @tweet = USERHANDLE.user("ashishait") 
    @tweet = @tweet.to_json()
    # puts @tweet.class
    @hash = JSON.parse(@tweet)
    # parse turns json to hash object
    @hash.each_key().each do |key|
      puts "--> #{key} -> #{@hash[key]}"
    end

  end

  desc "gets tweets of a user"
  task :gettweets => :environment do

  end

  desc "gets all the followers of a user"
  task :getfollowers => :environment do
    @count = 0 # counts the number of followers
    @followers_list = []
    @followers = USERHANDLE.follower_ids("tenderlove")

    @followers.each do |item|
      @followers_list.append(item) 
    end
    puts "Number of followers #{@followers_list.length}"
  end

  desc "checks the rate-limit status"
  task :checkratelimit => :environment do
    @requests_remaining = USERHANDLE.rate_limit_status()
    puts "Remaining requests = #{@requests_remaining}"
  end

  task :all => [:checkratelimit, :getfollowers, :checkratelimit]  
  # You don't need to supply a block of code to all task

end

