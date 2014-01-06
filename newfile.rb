require 'twitter'

p 'this is a ruby file'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YPC3v1fzpnJHeSfTNH2ZhQ"
  config.consumer_secret     = "bo6Or0GpaymfVccdaSliG8OGYHr4aYEtshZu4W2lCY"
  config.access_token        = "283990956-4SEvREjo1CmUWK4Lb9k8Kp2U5FkAMaVki46IxOAS"
  config.access_token_secret = "Gm57bk6esWS8VAIZNMazTn8o5tqPd3pDZqCBAYR8U"
end


