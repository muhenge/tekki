class Api::PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy vote]
  before_action :authenticate_user!, only: %i[index new create edit update show destroy vote]

  respond_to :json

  # GET /api/posts
  def index
    posts = Post.eager_load(:user, :comments, :career)
                .where(career_id: current_user.career_id)
                .most_recent

    user_posts = current_user.posts.eager_load(:user, :comments, :career).most_recent

    render json: { posts: posts, user_posts: user_posts }
  end


  # GET /api/posts/:id
  def show
    render json: { post: @post, comments: @post.comments }
  end

  # POST /api/posts
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      render json: { post: @post, message: 'Post created successfully' }, status: :created
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: { message: 'Updated successfully', post: @post }
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete post' }, status: :unprocessable_entity
    end
  end

  # POST /api/posts/:id/vote
  def vote
    if current_user.liked?(@post)
      @post.unliked_by(current_user)
      render json: { message: 'Post unliked' }
    else
      @post.liked_by(current_user)
      render json: { message: 'Post liked' }
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image, :user_slug, :created_at, :skill_id, career_ids: [])
  end

  def set_post
    @post = Post.includes(:comments).find_by(id: params[:id])

    unless @post
      render json: { error: 'Post not found' }, status: :not_found
    end
  end
end
