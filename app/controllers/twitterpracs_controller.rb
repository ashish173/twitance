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
		#p @par
		if @par 
			p "oh you make it"
		else
			p "does'nt exists"

		end
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
			#p @out
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
  		@options = {:count => "100"}  
  		p "in the download"+ q
		#@obj = @client.search(q, @options)

		token= "838203445-AOC6HFdUCZfAswXKVQQpdyCJImHoloyFVr1qZVSd"
		token_secret = "v93GUHb2zoR8bNYzrN81Ns36hzaC8KgBTYGO3cGM"

		obj = Rohit.new(token, token_secret)

		@obj =  obj.get(q, 100)
		#creating arrays of username, tweets
		results = []
		#@obj = @obj.to_a
		@obj.each do |t|
			d = {}
			d['type'] = "twitterprac"
			d['handle'] = t['user']['screen_name']
			d['tweet'] = t['text']
			results.push(d)
		end
=begin
		@obj.each do |t|
			d = {}
			d['type'] = "twitterprac"
			d['handle'] = t.user.screen_name
			d['tweet'] = t.text
			results.push(d)
		end
=end
		#indexing tweets
		Tire.index 'twitterpracs' do
      		delete

      		create :settings => {
            :index => {
              :analysis => {
                :analyzer => {
                  :twitance_analyzer => {
                    :type => 'snowball',
                    :tokenizer => 'snowball',
                    :language => 'English',
                    :stopwords_path => '/stop.txt'
                    #:stopwords => ['is', 'rt', 'you', 'to', 'the' , 't.co', 'me', 'http', 'https']
                  }
                }
              }
            }
          },
          :mappings => {
        		:twitterprac => {
          		:properties => {    
            		:handle     => { :type => 'string'},
            		:tweet  => { :type => 'string', :analyzer => 'twitance_analyzer'}
          }
        }
      }
    end
		Tire.index 'twitterpracs' do
			#delete
			import results
			refresh
		end
		return @obj
	end

	def search
		@q = params[:input]
		if @q
			@obj = download(@q)	
			redirect_to '/facets' 
		end
	end
end


class Rohit
	require 'faraday_middleware'
	attr_reader :token, :secret

	def initialize(token, secret)
		@token, @secret = token, secret
	end
	
	def get(q,count=1)
		res = connection(q,count).get #do |req|
		data =  res.body
		p data.class
		#p data
=begin
		i=0
		data['statuses'].each do |o|
	    	p o['text']
			p "user=" +o['user']['screen_name']    
			i+=1
		end
=end
		return data['statuses']
			#req.url path
		#end
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
