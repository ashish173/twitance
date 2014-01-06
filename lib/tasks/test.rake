require 'tire'

namespace :ashish do
  desc "create mapping"
  task :create do
    Tire.index 'ashishsingh' do
      delete

      create :mapping => {
        :ashish => {
          :properties => {
            :id => { :type => "string"},
            :text => { :type => "string", :analyzer => 'snowball'}
          }
        }
      }
    end
  end

  desc "insert data"
  task :insert do
    tweets = [{ :id => '1', :text => "ruby is a fine laguage"},
      { :id => '2', :text => "lets ruby this"}]
    
    Tire.index 'ashishsingh' do
      import tweets
    end
  end

  desc "search for words in tweets"
  task :search do
    
  end
end
