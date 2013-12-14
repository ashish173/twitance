# Stores all the information of a user
class User
  include Mongoid::Document
  field :name, type: String
  field :screen_name, type: String
  field :user_id, type: Integer
  field :description, type: String
  field :followers_count, type: Integer
  field :friends_count, type: Integer
  field :verified, type: Boolean
  field :profile_image_url, type: String
  field :lang, type: String
  field :description, type: String
  
  has_many :tweets
end
