require 'tire'

fd = File.new("new_tweets_16",'r')
pat = /\[Tweet:\s(.*),\screated_at:\s(.*),\slocation:\s(.*),\suser_id:\s(.*)\],/ # regex for extracting from file
if fd
  fd.each do |line|
    if line
      match = pat.match(line)   # returns the matchdata object
    end
    if match
      list = [{:type => "type16", :tweet => match[1], :created_at => match[2], :location => match[3], :user_id => match[4]  }]
      Tire.index 'tweetindex' do
        import list
        refresh
      end
    end
  end
end
