require 'tire'
require 'twitter'

class TweetsController < ApplicationController
  


  def index
    @tweet = Tweet.new
  end
  
  def create
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "YPC3v1fzpnJHeSfTNH2ZhQ"
      config.consumer_secret     = "bo6Or0GpaymfVccdaSliG8OGYHr4aYEtshZu4W2lCY"
      config.access_token        = "283990956-4SEvREjo1CmUWK4Lb9k8Kp2U5FkAMaVki46IxOAS"
      config.access_token_secret = "Gm57bk6esWS8VAIZNMazTn8o5tqPd3pDZqCBAYR8U"
    end
    # 1. Search twitter for search term
    # 2. Index in elasticsearch
    # 3. Fetch the facets
    p "text => #{params[:tweet][:text]}"
    # p "Here fucker #{@tweet.text}"
    search_term = params[:tweet][:text]
    p "search term => #{search_term}"
    # result = client.search(search_term, :count => 100)
=begin
    p ' search successfull'
    result_array = []
    result.to_a.each do |result|
      tweet_hash= {}
      tweet_hash[:text] = result.text
      result_array.push(tweet_hash)
    end


  
    Tire.index 'tweetindex' do
      p 'indexing in database'
      import result_array
    end
=end
    @s = Tire.search 'tweetindex' do
      query do
        string "#{search_term}"
      end

      facet 'wordcount' do
        terms :text
      end
    end

    p "Here mofo #{@s.class}"
  
    p "first element"
    # s.results.facets['wordcount']['terms'].each do |f|
    # end
  end

  

end
  
