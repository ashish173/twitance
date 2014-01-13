# @path = Rails.root.join("new_tweets_ruby3")


namespace :tag do
  desc "create tags from already indexed tweets"
  task :create do
    
  end
  
  desc "filter the tags based on the rejections"
  task :filter do
    
  end

  task :all => [:create, :filter]

  # show all the tags
  def show_tags()
    
  end

end
