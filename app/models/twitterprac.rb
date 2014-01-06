class Twitterprac 
  include Mongoid::Document
	
  include Tire::Model::Search
	include Tire::Model::Callbacks
  #attr_accessible :handle, :tweet
  field :handle, type: String
  field :tweet, type: String


  mapping do 
  	indexes :handle,	:index => :not_analyzed
  	indexes :tweet, 	:analyzer => 'snowball'
  end
end