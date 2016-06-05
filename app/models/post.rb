class Post < ActiveRecord::Base
<<<<<<< HEAD
	has_many :comments, dependent: :destroy
	belongs_to :topic
=======
	has_many :comments

>>>>>>> a2efc6be526a104e53767a2ccf215aec48023850
end
