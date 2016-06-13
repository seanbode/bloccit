FactoryGirl.define do
  factory :vote do
    value 1
    post
    user
    #error keeps calling for rank.
  end
end
