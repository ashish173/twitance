require "twitter"
require "tire"
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YPC3v1fzpnJHeSfTNH2ZhQ"
  config.consumer_secret     = "bo6Or0GpaymfVccdaSliG8OGYHr4aYEtshZu4W2lCY"
  config.access_token        = "283990956-4SEvREjo1CmUWK4Lb9k8Kp2U5FkAMaVki46IxOAS"
  config.access_token_secret = "Gm57bk6esWS8VAIZNMazTn8o5tqPd3pDZqCBAYR8U"
end
=begin
def collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield max_id
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def fetch_all_tweets(user) 
  collect_with_max_id do |max_id|
    options = {:count => 200, :include_rts => true}
    options[:max_id] = max_id unless max_id.nil?
    top = @client.user_timeline(user, options)
  end
  
end
=end


search_term = ARGV[0]
# p search_term.class

# fetch_all_tweets("ashishait")
#
options = {:count => 100}  
# test = @client.user_timeline("ashishait", options)
test = client.search(search_term, options)



result_array = []

test.to_a.each do |result|
  tweet_hash={}
  tweet_hash[:text] = result.text
  result_array.push(tweet_hash)
end


Tire.index 'tweetindex' do
  import result_array
end


# search_t = "#{@search_term}"

s = Tire.search 'tweetindex' do
  query do 
    string search_term
  end

  facet 'wordcount' do
    terms :text
  end
end

s.results.facets['wordcount']['terms'].each do |f|
  puts "#{f['term']} ==> #{f['count']}"
end


