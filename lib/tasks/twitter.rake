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
    @tweets = USERHANDLE.user_timeline(@selecteduser)
    # we now have array of twitter objects
    @tweets_json = @tweets.to_json()
    # we now get array of json objects
    @tweets_hash = JSON.parse(@tweets_json)
    # we now get array of hashes(converted from json)
    #
    @tweets_hash.each do |item|
      #puts "=>> #{item} --> #{@tweets_hash[item]}"
      # puts "tweet #{item['text']}"
      # store_tweet_to_file(item)      # stores tweet to file
      store_stats_to_file(item)      # stores the details of tweets of a user
    end
  end

  desc "stores the stats of a user for his tweets"
  task :calculatestats => :environment do
      
  end

  desc "processes tweets of a user"
  task :processtweets => :environment do
    fd = File.open("tweets/#{@selecteduser}_tweets")
    @tweets_array = []
    while(line = fd.gets)
      # @line = line.to_json()
      # @tweet_rec = JSON.parse(@line)
      @tweets_array.append(line)
    end
    puts "class of line = #{@tweets_array[0].class}"
    # @tweets_hash = JSON.parse(@tweets_array)

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
  desc "all task will run any task given in array"
  task :all => [:gettweets]  
  # You don't need to supply a block of code to all task
  
  # formal parameters cannot be instance variables
  def set_user(selectuser)
    #@user = selectuser
  end
  
  def extract_link(tweet)
    @start_index = tweet.index(/http:\/\/[\S]+/)
    # puts "start index found at #{@start_index}"
    if(@start_index)
      @end_index = tweet[@start_index, tweet.length].index(/\s/)
      if(!@end_index)
        @end_index = tweet.length-1
      end
      # puts "end index found at #{@end_index}"
    end
    if(@start_index and @end_index)
      # puts "Now modifying tweet"
      if(@end_index == tweet.length-1)
        tweet = tweet[0, @start_index]
      else
        tweet = tweet[0, @start_index-1] + tweet[@start_index+@end_index, tweet.length]
      end
    end
    return tweet
  end

  def calc_word_count(tweet)
    word_count = {}  # keeps track of count of words in a tweet
    # extract the links
    tweet = extract_link(tweet)
    if(tweet.index(/http:\/\/[\S]+/))
      tweet = extract_link(tweet)
    end
    # then split the string
    # puts tweet
    words = tweet.split(/\W+/)   #/\W/ - A non-word character ([^a-zA-Z0-9_])]
    # puts "length of array #{words.length}"
    # chopped_words = extract_word(words)
    words.each do |word|
      if (word_count.include?(word))
        word_count[word] = word_count[word] + 1
      else
        word_count[word] = 1
      end
    end
    
    word_count.each_key().each do |key|
      puts "#{key} --> #{word_count[key]}"
    end
  end

=begin  
  # extract word from the ambiguous word
  #
  def chop_word(word)
    new_word = nil
    (0..word.length).each do |index|
      if(!word[index].match(/[:alnum:]/))
        new_word = word[0, index-1]
        break
      end
    end
    return new_word
  end

  # returns a word if it has punctuations line Hello!!! --> Hello | Violla; --> Violla
  def extract_word(word_array)
    puts "class of word array is #{word_array.class}"
    
    (0..word_array.length).each do |index|
      if(!word_array[index][-1].match(/[:alnum:]/))   # undefined method alpha for 'A'.alpha()
        chopped_word = chop_word(word_array[index])
        word_array[index] = chopped_word
      end
    end    
    return word_array
  end

  class String
    def alpha? # omits punctuations
      !!match(/^[[:alnum:]]+$/)
    end
  end
=end

  # writes stats of a user to file
  def store_stats_to_file(tweet_hash)
    # count the number of words
    @tweet_text = tweet_hash['text']
    @word_count = calc_word_count(@tweet_text) # calculate word count in a tweet
    # mentions
    #
    fd = File.open("tweets/#{@selected_user}_stats", "w+")  # opening in read write mode
    if fd
      
    end
  end

  # Writes files to a file username_tweets 
  def store_tweet_to_file(tweet_hash)
    fd = File.open("tweets/#{@selecteduser}_tweets", "a")  # opening in append mode
    if fd
       fd.syswrite("#{tweet_hash}\n")
    end
  end

end

