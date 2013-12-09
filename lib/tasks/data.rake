# data input in database

@pathtofile ="../../ratelimits/new_tweets_ruby"
# opens tweet files and extract a tweet

namespace :database do
	desc "reads a tweet from file"
	task :readtweet => :environment do
		fd = File.open(@pathtofile, "r") # open in read mode
		if fd
			p "file open successfull"
		end
	end

	desc "create and save in database"
	task :insertindb => :environment do

	end

end

# create a mongoid object
# mongoid object should be save