class Topic < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :labelings, as: :labelable
  has_and_belongs_to_many :comments
  # has_many :topiclings,
  has_many :labels, through: :labelings
end
