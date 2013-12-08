require "twitter"

@client = Twitter::REST::Client.new do |config|
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


# fetch_all_tweets("ashishait")
#
options = {:count => 200}  
test = @client.user_timeline("ashishait", options)
p "The result is #{test.length}" 
