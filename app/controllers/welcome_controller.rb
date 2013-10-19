class WelcomeController < ApplicationController
  # just for the sake of testing
  def index
    @tweet = USERHANDLE.user("rohitkhatana3")
    p "my tweet" # show on console
    p @tweet     
  end
end
