require 'rubygems'
require 'tire'
# require 'yaml/json_gem'


Tire.index 'tweetindex' do
  delete
  
  create :mappings => {
    :tweetindex => {
      :properties => {
        :id  => {:type => 'string', :index => 'not_analyzed', :include_in_all => false},
        :tweet => { :type => 'string', :analyzer => 'snowball' },
        :created_at => {:type => 'date'},
        :location => {:type => 'string', :analyzer => 'keyword' },
        :user_id => {:type => 'string'}
      }
    }
  }
end
