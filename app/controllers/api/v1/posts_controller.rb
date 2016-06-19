class Api::V1::PostsController < Api::V1::BaseController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show]

=begin
  def index
    topic = Topic.find(params[:topic_id])
    posts = Post.all
    render json: posts.to_json, status: 200
  end

  def show
    post = Post.find(params[:id])
    render json: post.to_json(include: :comments), status: 200
  end
=end

  def update
    post = Post.find(params[:id])

    if post.update_attributes(post_params)
      render json: post.to_json, status: 200
    else
      render json: {error: "Post update failed", status: 400}, status: 400
    end
  end

  def create # running into errors. not creating. curl not functioning either.
    topic = Topic.find(params[:topic_id]) 
    post = topic.posts.build(post_params)
    post = Post.new(post_params)
    @current_user = post.user

    if post.user == @current_user #post.valid? # how do I render this true
    post.save
    render json: post.to_json, status: 201 #why is this not succeeding
    else
      render json: {error: "Post is invalid", status: 400}, status: 400
    end
  end

  def destroy
    post = Post.find(params[:id])

    if post.destroy
      render json: {message: "Post destroyed", status: 200}, status: 200
    else
      render json: {error: "Post destroy failed", status: 400}, status: 400
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :public)
  end

  def authorize_user_for_posts_controller
    unless @current_user
      render json: { error: "Not Authorized", status: 403 }, status: 403
    end
  end
end
