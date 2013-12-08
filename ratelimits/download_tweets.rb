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
#@index = "FCBarcelona"
#@index = "thingsiliketosee"
# This will pull a sample of all tweets based on
# your Twitter account's Streaming API role.

TweetStream::Client.new.track(@index, "rails", "rubyonrails", "rubygem", "#ruby", "#rubyonrails", "#rubygem") do |status|
  # The status object is a special Hash with
  # method access to its keys.
  puts "Tweet: #{status.text}"
  puts "Date: #{status.created_at}"
  puts "Id: #{status.id}" 
  puts "Location: #{status.user.location}"

  file = File.new("new_tweets_ruby1","a+")
  # put "file descriptpr: #{file}"
  @tweet_json = status.to_json()
  if file 
    file.syswrite("#{@tweet_json},")
    #,#{status.text},#{status.created_at},#{status.user.screen_name},#{status.location}")
    #file.syswrite(", created_at: #{status.created_at}")
    #file.syswrite(", location: #{status.user.location}")
    #file.syswrite(", user_id: #{status.id}],")
    file.syswrite("\n")
    file.close()
  else
    puts "could not open file"
  end
=begin
  list = [{:type => @index, :tweet => status.text, :created_at => status.created_at, :user_name => status.user.screen_name }]
  
  #Tire.index 'twitdata' do
  #  import list
  #  refresh
  #end
=end
end
=begin
TweetStream::Client.new.sample do |status|
  puts "#{status.text}"
end
=end

