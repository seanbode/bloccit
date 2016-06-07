class Topic < ActiveRecord::Base
  has_many :posts, :sponsoredposts dependent: :destroy
end
