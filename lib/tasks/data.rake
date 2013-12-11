# data input in database
require 'json'

@pathtofile = Rails.root.join "lib/tasks/tweetsample"
# Rails.root return path "/" which is root path



# opens tweet files and extract a tweet

namespace :database do
	desc "reads a tweet from file"
	task :readtweet => :environment do
		# fd = File.open(@pathtofile, "r") # open in read mode
		File.readlines(@pathtofile).each do |line|
			line=line.chomp().chop()
			my_hash = JSON.parse(line)
			
			#p my_hash['user']['screen_name']
			#p my_hash.class
			@tweet = Tweet.new(created_at: my_hash['created_at'], text: my_hash['text'])
      @tweet.save!
			p "tweet entered in mongodb"
      @alltweets = Tweet.all()
      p "class of alltweets #{@alltweets.class}"
		end
	end

	desc "create and save in database"
	task :insertindb => :environment do

	end

end

# create a mongoid object
# mongoid object should be save
