# data input in database
require 'json'
require "rubygems"
require "tire"

@pathtofile = Rails.root.join "lib/tasks/tweetsample"
# Rails.root return path "/" which is root path

=begin
field :tweet_id, type: Integer  
  field :created_at, type: DateTime
  field :text, type: String         
  field :user_id, type: Integer       
  field :in_reply_to_status_id, type: Integer
  field :in_reply_to_user_id, type: Integer
  field :in_reply_to_screen_name, type: String
  field :hashtags, type: Array  # stores the hashtags in an array
  field :urls, type: Array      # same with urls
  field :mentions_id, type: Array   
  field :favourited, type: Boolean  
  field :retweeted, type: Boolean  
  field :lang, type: String

if(User.find(u_id))
  ty = User.first.tweets.new(:text => "this is fifth tweet 4th skipped for first object")
  ty.save
end
=> true 

=end
# opens tweet files and extract a tweet
namespace :tweet do
	desc "reads a tweet from file"
	task :read => :environment do
		# fd = File.open(@pathtofile, "r") # open in read mode
		File.readlines(@pathtofile).each do |line|
			line=line.chomp().chop()
			tweet_hash = JSON.parse(line)
			#@user_id = tweet_hash['user']['id']
			twitana=[:tweet_id => tweet_hash['id_str'],:text => tweet_hash['text']]	
			Tire.index 'twitana' do
				import twitana
			end
		end
	end

=begin			if(User.where(:id => @user_id).exists?)
				@user = User.find(@user_id).tweets.new(created_at: tweet_hash['created_at'], text: tweet_hash['text'], tweet_id: tweet_hash['id_str'], in_reply_to_status_id: tweet_hash['in_reply_to_status_id_str'], in_reply_to_user_id: tweet_hash['in_reply_to_user_id_str'], in_reply_to_screen_name: tweet_hash['in_reply_to_screen_name'], hashtags: tweet_hash['entities']['hashtags'], urls: tweet_hash['entities']['urls'], mentions_id: tweet_hash['entities']['user_mentions'], favorite_count: tweet_hash['favorite_count'], retweet_count: tweet_hash['retweet_count'], lang: tweet_hash['lang'])
				@user.save
			#	p "update existing record"
			else
				@user = User.create(name: tweet_hash['user']['name'], screen_name: tweet_hash['user']['screen_name'], user_id: tweet_hash['user']['id_str'], description: tweet_hash['user']['description'], followers_count: tweet_hash['user']['followers_count'], friends_count: tweet_hash['user']['friends_count'], verified: tweet_hash['user']['verified'], profile_image_url: tweet_hash['user']['profile_image_url'], lang: tweet_hash['user']['lang'], description: tweet_hash['user']['description'])
				@user.tweets.create(created_at: tweet_hash['created_at'], text: tweet_hash['text'], tweet_id: tweet_hash['id_str'], in_reply_to_status_id: tweet_hash['in_reply_to_status_id_str'], in_reply_to_user_id: tweet_hash['in_reply_to_user_id_str'], in_reply_to_screen_name: tweet_hash['in_reply_to_screen_name'], hashtags: tweet_hash['entities']['hashtags'], urls: tweet_hash['entities']['urls'], mentions_id: tweet_hash['entities']['user_mentions'], favorite_count: tweet_hash['favorite_count'], retweet_count: tweet_hash['retweet_count'], lang: tweet_hash['lang'])
				@user.save
			#	p "made a new record"
			end
=end
	task :create => :environment do
		Tire.index 'twitana' do
			delete
			create :mappings => {
								:twitana => {
									:properties => {
										:tweet_id => {:type => 'string', :index => 'not analyzed'},
						 				#:created_at => {:type => 'DateTime'},
										:text => {:type => 'string', :analyzer => 'snowball',:language => 'English'},
									}
								}
							}
		end
	end
=begin
	desc "insert into in database"
	task :insert => :environment do
		Tire.index 'twitana' do
			import twitana
		end
	end

	desc "fetch all tweets of a user"
	task :fromuser => :environmnet do

	end

	desc "match tweet against the seed file of words concering an interest"
	task :match => :environment do

	end

	desc "adds user to temp list of category"
	task :adduser => :environment do

	end
=end
	task :display => :environment do
			  
		  s = Tire.search 'twitana' do
	      		query do 
	      			string ('text:ruby*')
	      		end
	      		
	      		facet 'tags' do
	      			terms :text
	      		end
	      	end
	    	s.results.each do |document|
	    		puts "* #{document.tweet_id} , #{document.text}"
	    	end 
	    	s.results.facets['tags']['terms'].each do |f|
	    		puts "#{f['term'].ljust(10)}#{f['count']}"
	    	end 
	end
		task :all => [:read,:create,:display]
		# parsing of account of users from the temp list of category
		# in another file parse.rake
end

# create a mongoid object
# mongoid object should be save
