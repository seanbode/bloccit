require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:topic) { create(:topic) }
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:vote) { create(:vote) }

  it { is_expected.to belong_to(:post) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }

  describe "update_post callback" do
    it "triggers update_post on save" do #this is functional when update rank is not! update rank is a part of update post.
      expect(vote).to receive(:update_post).at_least(:once)
      vote.save!
    end

    it "#update_post should call update_rank on post " do #
      expect(post).to receive(:update_rank).at_least(:once)
      vote.save!
    end

    #it "updates the rank when an up vote is created" do
    #  old_rank = post.rank
    #  post.votes.create!(value: 1)
    #  expect(post.rank).to eq (old_rank + 1)
    #end

    #it "updates the rank when a down vote is created" do
    #  old_rank = post.rank
    #  post.votes.create!(value: -1)
    #  expect(post.rank).to eq (old_rank - 1)
    #end
  end
end
