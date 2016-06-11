class Comment < ActiveRecord::Base
  belongs_to :post
  has_and_belongs_to_many :topics
  #belongs_to :topic
  belongs_to :user

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true
end
