require 'tweetstream'
require 'multi_json'
require 'tire'


TweetStream.configure do |config|
    config.consumer_key       = 'kgIpenTTZcD7wD9dnOOxPQ'
    config.consumer_secret    = 'hHWxrOaZ3e1P9q44q6t0tNLvHZXucKETg2CGuchsmRc'
    config.oauth_token        = '838203445-5H2Qq5gRceSmLMXmHgtzDDWPUmGMzbEXRJtLjRNv'
    config.oauth_token_secret = 'DMvzqeNW6DhqM26lUyx4VhnM3s5NlwmLQ4IV9fuORHg'
    config.auth_method        = :oauth
end
@index = "nike"
#@index = "FCBarcelona"
#@index = "thingsiliketosee"
# This will pull a sample of all tweets based on
# your Twitter account's Streaming API role.
TweetStream::Client.new.track(@index) do |status|
  # The status object is a special Hash with
  # method access to its keys.
  puts "Tweet: #{status.text}"
  puts "Date: #{status.created_at}"
  puts "Id: #{status.id}" 
  puts "Location: #{status.user.location}"

  file = File.new("new_tweets_16","a+")
  # put "file descriptpr: #{file}"
  if file 
    file.syswrite("[Tweet: #{status.text}")#,#{status.text},#{status.created_at},#{status.user.screen_name},#{status.location}")
    file.syswrite(", created_at: #{status.created_at}")
    file.syswrite(", location: #{status.user.location}")
    file.syswrite(", user_id: #{status.id}],")
    file.syswrite("\n")
    # file.close()
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

