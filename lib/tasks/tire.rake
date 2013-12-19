#1. make mappings
#2. insert tweet
#3. query using tire
require "rubygems"
require "tire"
namespace :tire do
	task :create do
		Tire.index 'twitance' do
			delete
			create :mappings => {
								:twitance => {
									:properties => {
										:tweet_id => {:type => 'string', :index => 'not analyzed'},
										:text => {:type => 'string', :analyzer => 'snowball'}
									}
								}
							}
		end
	end


task :read do
	
end
	task :insert do
		twitance = [
			{:tweet_id => '1', :text => 'Ashish this might not work'},
			{:tweet_id => '2', :text => 'lets see what all is gonna happen'}		
		]
		Tire.index 'twitance' do
			import twitance
		end
	end

	task :view do
		  s = Tire.search 'articles' do
      	query do
        	string 'this'
      	end
      end
    s.results.each do |document|
    	puts "#{document.tweet_id}  #{document.text}"
    end  
	end
end
	