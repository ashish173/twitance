#1. make mappings
#2. insert tweet
#3. query using tire
require "rubygems"
require "tire"
require 'json'
@pathtofile = Rails.root.join "lib/tasks/tweetsample"
namespace :tire do
	task :insert => :environment do
		twitance = [
			{:tweet_id => '1', :text => 'Ashish this might not work'},
			{:tweet_id => '2', :text => 'lets see what all is gonna happen'},
			{:tweet_id => '3', :text => 'Ruby on rails is a new concept for me'},
			{:tweet_id => '4', :text => 'Let me get you a ruby necklace'},
			{:tweet_id => '5', :text => 'Working on Rails sometimes makes u wonder why wasnt this the startup language'},
			{:tweet_id => '6', :text => 'This was the first time ever i worked on ROR(rubyonrails)'},		
			{:tweet_id => '7', :text => 'I love Ruby'},
			{:tweet_id => '7', :text => 'You are gonna make me work with this all night'},
			{:tweet_id => '6', :text => 'Ruby is a programming language'},	
			{:tweet_id => '6', :text => 'We are gonna run this in Ruby'}	

		]
		Tire.index 'twitance' do
			import twitance
		end
	end
	


	task :view => :environment do
	  s = Tire.search 'twitance' do
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
	

	task :create => :environment do
		Tire.index 'twitance' do
			delete
			create :mappings => {
								:twitance => {
									:properties => {
										:tweet_id => {:type => 'string', :index => 'not analyzed'},
						 				#:created_at => {:type => 'DateTime'},
										:text => {:type => 'string', :analyzer => 'snowball',:language => 'English'},
										#:user_id => {:type => 'String'},
										#:in_reply_to_status_id => {:type => 'String'},
										#:in_reply_to_user_id => {:type => 'String'},
										#:in_reply_to_screen_name => {:type => 'String'},
										#:hashtags => {:type => 'Array.new(10) { |i|  }'},
										#:urls => {:type => 'Array.new(10) { |i|  }'},
										#:mentions_id => {:type => 'Array.new(10) { |i|  }'},
										#:favorite_count => {:type => 'Integer'},
										#:retweet_count => {:type => 'Intege'},
										#:lang => {:type =>'String'}
									}
								}
							}
		end
	end


	task :read => :environment do
		File.readlines(@pathtofile).each do |line|
			line=line.chomp().chop()
			tweet_hash=JSON.parse(line)
			twitance=[{:tweet_id => tweet_hash['id_str'],:text => tweet_hash['text']}]		
			Tire.index 'twitance' do
				import twitance
			end
		end
	end

	task :manual => [:view,:read,:create]
	#task :auto => [:create,:insert,:view]
end
	