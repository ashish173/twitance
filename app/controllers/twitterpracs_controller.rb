class TwitterpracsController < ApplicationController
	require 'twitter'
	require 'tire'
	def new
		render "new"
	end


	def create 
		@tweet = Twitterprac.new(params[:tweet])
		@tweet.save
		redirect_to @tweet
		#render text: params[:tweet].inspect
	end


	def facets
		@par = params[:term]
		p @par
		if @par 
			p "oh you make it"
		else
			p "does'nt exists"

		end
=begin
		@sea = Twitterprac.search do 
			facet 'word', :global => true do
        		terms :tweet
      		end
			#facet('word') {}
		end
=end
	@sea = Tire.search 'twitterpracs' do
		    facet 'word', :global => true do
        		terms :tweet
      		end
	end
		
		@out = Twitterprac.search do
			query{string 'ruby'}#, fuzziness: 0.5} 
		end


		if @out
			p "outexists "
			@out.results.each do |f|
				#p f['tweet']
			end
			p @out
		else
			p "try hard "
		end		
	end
	#end

	def show
		@tweet = Twitterprac.find(params[:id])
		if @tweet
			p "tweet exit"
		else 
			p "not exits"
		end
		#@sea = Twitter.search(params)#all #search(:facet => { })

		@sea = Twitterprac.search do 
			facet 'word', :global => true do
        		terms :tweet
      		end
			#facet('word') {}
		end

		if @sea
			p "sae exists "
			p "#{@sea.facets['word']['terms'][0]['term']}"
			p "#{@sea.facets['word']['terms'][0]['count']}"
		else
			p "try hasd "
		end		
	end
	#hitting the twitter

	def download(q)
		@client = Twitter::REST::Client.new do |config|
  			config.consumer_key        = "kgIpenTTZcD7wD9dnOOxPQ"
  			config.consumer_secret     = "hHWxrOaZ3e1P9q44q6t0tNLvHZXucKETg2CGuchsmRc"
			config.access_token        = "838203445-AOC6HFdUCZfAswXKVQQpdyCJImHoloyFVr1qZVSd"
  			config.access_token_secret = "v93GUHb2zoR8bNYzrN81Ns36hzaC8KgBTYGO3cGM"
  		end	
  		options = {:count => 100}  
		@obj = @client.search(@q, options)

		#creating arrays of username, tweets
		results = []
		#@obj = @obj.to_a
		@obj.each do |t|
			d = {}
			d['handle'] = t.user.screen_name
			d['tweet'] = t.text
			results.push(d)
		end
		#indexing tweets
		Tire.index 'twitterpracs' do
			import results
		end

		return @obj
	end

	def search
		@q = params[:input]
		if @q
			@obj = download(@q)	
		end
		
	end
end