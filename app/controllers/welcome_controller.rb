class WelcomeController < ApplicationController
  def index
     # @tweet =  USERHANDLE.search("#ruby", :lang => "en", :count => 1).results.first.text
     # @tweet =  USERHANDLE.retweets_of_me
    # @tweet = USERHANDLE.mentions_timeline # returns the timeline
    #@tweet = USERHANDLE.retweeters_of(388205958628790272, options={})
    # @tweet = USERHANDLE.home_timeline
     #@tweet = USERHANDLE.retweeters_of(388442551012691968, options={})
    # @tweet = USERHANDLE.user_timeline("ashishait")
      @tweet = USERHANDLE.user("rohitkhatana3")
    p "my tweet" # show on console
    p @tweet     
  end
end
