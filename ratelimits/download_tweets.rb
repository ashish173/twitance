require 'tweetstream'
require 'multi_json'
require 'tire'


TweetStream.configure do |config|
    config.consumer_key       = 'YPC3v1fzpnJHeSfTNH2ZhQ'
    config.consumer_secret    = 'bo6Or0GpaymfVccdaSliG8OGYHr4aYEtshZu4W2lCY'
    config.oauth_token        = '283990956-4SEvREjo1CmUWK4Lb9k8Kp2U5FkAMaVki46IxOAS'
    config.oauth_token_secret = 'Gm57bk6esWS8VAIZNMazTn8o5tqPd3pDZqCBAYR8U'
    config.auth_method        = :oauth
end
@index = "ruby"
# This will pull a sample of all tweets based on
# your Twitter account's Streaming API role.

TweetStream::Client.new.track(@index, "rails", "rubyonrails", "rubygem", "#ruby", "#rubyonrails", "#rubygem") do |status|
  puts "Tweet: #{status.text}"

  file = File.new("new_tweets_ruby3","a+")
  # put "file descriptpr: #{file}"
  @tweet_json = status.to_json()
  if file 
    file.syswrite("#{@tweet_json},")
    file.syswrite("\n")
    file.close()
  else
    puts "could not open file"
  end
end

