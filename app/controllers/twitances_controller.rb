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
    inpu =  params[:q]
    p "---------->" + inpu
    @sea=Tire.search 'twitances' do
      query do
        match [:tweet, :description, :name], inpu #'python'
      end
      size 1000

      facet 'word', :global => true do
        terms :tweet
      end
    end


    @user = Tire.search 'twitances' do
      query do
        string inpu #, fuzziness: 0.5} 
      end
    end
    count = 0
    @user.results.each do 
      count = count + 1
    end
     p "==============================="
    p count
    #p @sea.results.facets['word']["terms"].fit
  end

  def show
    @tweet = Twitance.find(params[:id])
    if @tweet
      p "tweet exit"
    else 
      p "not exits"
    end

    @sea=Twitance.search do 
      facet 'word', :global => true do
        terms :tweet
      end
    end
  end
  #hitting the twitter

def download(q)
  token = "838203445-AOC6HFdUCZfAswXKVQQpdyCJImHoloyFVr1qZVSd"
  token_secret = "v93GUHb2zoR8bNYzrN81Ns36hzaC8KgBTYGO3cGM"

  obj = Rohit.new(token, token_secret)

  @tweet_obj =  obj.get(q, 100)
  #creating arrays of username, tweets
  results = []
  #@obj = @obj.to_a
  @tweet_obj.each do |t|
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
    #indexing tweets
  Tire.index 'twitances' do
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
      :twitance => {
        :properties => {    
          :handle   	  => { :type => 'string'},
          :followers	  => {:type 	=> 'integer'},
          :friends	  => {:type 	=> 'integer'},
          :name 		  => {:type 	=> 'string'},
          :profile_image_url=> {:type 	=> 'string'},
          :description      => {:type=> 'string', :analyzer => 'twitance_analyzer'},
          :verified 	  => {:type 	=> 'boolean'},
          :tweet  	  => { :type => 'string', :analyzer => 'twitance_analyzer'}
        } 
      }
    }
  end

  Tire.index 'twitances' do
    import results
    refresh
  end
end

  def search
    @q = params[:input]
    if @q
      download(@q)	
      redirect_to '/facets?q='+@q 
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
