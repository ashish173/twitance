class TwitancesController < ApplicationController
	require 'twitter'
	require 'tire'

	def new
		render "new"
	end

	def create 
		@tweet = Twitance.new(params[:tweet])
		@tweet.save
		redirect_to @tweet
		#render text: params[:tweet].inspect
	end


	def facets
    inpu = session[:pass]
   
		@sea = Tire.search 'twitances' do
         # query {string 'AAP'}
        
          query do
            match [:tweet, :description, :name], inpu
            p '-------------------'
            p @inpu.to_s
          """
            multi_match do
              string 'AAP'
              fields ['tweet', 'description']
            end
            string 'tweet:AAP'#session[:pass]  
            string 'description:AAiP'"""
          end
          size 1000 
			    facet 'word', :global => true do
        			terms :tweet   #,:description
      		end
          """
          facet('multi'){ terms ['tweet' , 'description']}
          """
		end
    count = 0
    @sea.results.each do 
      count = count + 1
    end
    p "==============================="
    p count
		value=session[:pass]
    p "---------------------------------"
    p value
		@user = Tire.search 'twitances' do
			query do
				string value
			end 
		end
	end
  
	def show
		@tweet = Twitance.find(params[:id])
		if @tweet
			p "tweet exit"
		else 
			p "not exits"
		end

		@sea = Twitance.search do 
			facet 'word', :global => true do
        		terms :tweet,:description
      		end
			#facet('word') {}
		end
	end
	#hitting the twitter

	def download(q)

		token_first = APP_CONFIG['KEY']
		token_take = APP_CONFIG['SECRET_KEY']

		key = TwitterAccess.new(token_first, token_take)

		@tweet_key =  key.get(q, 100)
		#creating arrays of username, tweets
		results = []
		#@obj = @obj.to_a
		@tweet_key.each do |t|
			store_data = {}
			store_data['type'] 			= "twitance"
			store_data['handle'] 		= t['user']['screen_name']
			store_data['tweet'] 		= t['text']
			store_data['name']			= t['user']['name']
			store_data['description'] 	= t['user']['description']
			store_data['followers'] 	= t['user']['followers_count']
			store_data['friends'] 		= t['user']['friends_count']
			store_data['verified'] 		= t['user']['verified']
			store_data['profile_image_url']				= t['user']['profile_image_url']
			results.push(store_data)
		end
		%x[rake mapping]
		Tire.index 'twitances' do

			import results
			refresh
		end
	end

	def search
		@q = params[:input]
		session[:pass]=params[:input]
		if @q
			download(@q)	
			redirect_to '/facets'
		end
	end
end


class TwitterAccess
	require 'faraday_middleware'
	attr_reader :token, :secret

	def initialize(token, secret)
		@token, @secret = token, secret
	end
	
	def get(q,count=1)
		res = connection(q,count).get #do |req|
		data =  res.body
		p data.class

		return data['statuses']
	end
	
	private
	def connection(q, count=1)
		arr = q.split(" ")
		q = arr.join("+")
		@search_url = 'https://api.twitter.com/1.1/search/tweets.json'
		@search_url += "?q="+q+"&"+"count="+count.to_s+"&lang=en"
		p @search_url
		@connection ||= Faraday.new(url: @search_url) do |conn|
			conn.request	:url_encoded
			conn.request	:oauth, oauth_data
			conn.response	:json, :content_type => /\bjson$/
			conn.use 	:instrumentation
			conn.adapter	Faraday.default_adapter
		end
	end

	def oauth_data
		{
			consumer_key:	consumer_key,
			consumer_secret: consumer_secret,
			token: token,
			token_secret: secret
		}
	end

	def consumer_key
		return "kgIpenTTZcD7wD9dnOOxPQ"	
	end

	def consumer_secret
		return "hHWxrOaZ3e1P9q44q6t0tNLvHZXucKETg2CGuchsmRc"
	end
	
end
