# Stores all the information of a user
class User
  include Mongoid::Document
  field :name, type: String
  field :screen_name, type: String
  field :user_id, type: Int
  field :description, type: String
  field :followers_count type: Int
  field :friends_count, type: Int
  field :verified, type: Boolean
  field :profile_image_url, type: String
  field :lang, type: String
  field :description, type: String
  
  embeds_many :tweets    # has one to many relation with tweet model
end
