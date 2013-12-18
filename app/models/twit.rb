class Twit
  include Mongoid::Document

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :id,   :index   => :not_analyzed
    indexes :text, :analyzer => 'snowball'  
    indexes :published_on => DateTime
  end
end
