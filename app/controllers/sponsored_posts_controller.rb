class SponsoredPostsController < ApplicationController
  def show
    @sponsored_post = sponsored_post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
  	@sponsored_post = Sponsored_post.new
  end

  def edit
    @sponsored_post = Sponsored_post.find(params[:id])
  end
end
