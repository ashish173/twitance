# USERHANDLE is a Twitter::Client object defined in intializers 

# change this to change the user
@selecteduser = "ashishait"
# @user is the instance variable that holds current user
#

namespace :run do
  desc "Greets on terminal hello world"
  task :greet do
    puts "Hello world"
  end
  
  desc "gets info for a user"
  task :getuserinfo => :environment do
    @tweet = USERHANDLE.user(@selecteduser) 
    @user = @tweet.to_json()
    
    @user_hash = JSON.parse(@user)
    # parse turns json to hash object
    # There is also faraday middleware that can do parsing without needing to explicitly call JSON.parse
    
    @user_hash.each_key().each do |key|
      puts "--> #{key} -> #{@user_hash[key]}"
    end
  end

  desc "gets tweets of a user"
  task :gettweets => :environment do
    @tweets = USERHANDLE.user_timeline("ashishait")
    # we now have array of twitter objects
    @tweets_json = @tweets.to_json()
    # we now get array of json objects
    @tweets_hash = JSON.parse(@tweets_json)
    # we now get array of hashes(converted from json)
    #
    @tweets_hash.each do |item|
      #puts "=>> #{item} --> #{@tweets_hash[item]}"
      puts "tweet #{item['text']}"
      store_tweet_to_file(item)
    end
  end

  desc "gets all the followers of a user"
  task :getfollowers => :environment do
    @count = 0 # counts the number of followers
    @followers_list = []
    @followers = USERHANDLE.follower_ids(@selecteduser)

    @followers.each do |item|
      @followers_list.append(item) 
    end
    puts "Number of followers #{@followers_list.length}"
  end

  desc "checks the rate-limit status"
  task :checkratelimit => :environment do
    # puts "Remaining requests = #{@requests_remaining}"
  end

  desc "sets current user"
  task :setuser do
    set_user(@selecteduser)  # calls a custom method
  end

  desc "display current user"  
  task :displayuser do
    puts "User #{@user}"
  end

  task :all => [:gettweets]  
  # You don't need to supply a block of code to all task
  
  # formal parameters cannot be instance variables
  def set_user(selectuser)
    #@user = selectuser
  end
  
  # Writes files to a file username_tweets 
  def store_tweet_to_file(tweet_hash)
    fd = File.new("#{@selecteduser}_tweets", "a")
    if fd 
       fd.syswrite("#{tweet_hash}\n")
    end
  end

end

