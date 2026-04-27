class Api::PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy vote]
  before_action :authenticate_user!, only: %i[index new create edit update show destroy vote]

  respond_to :json

  #
  def index
    @posts = if current_user.career_ids.any?
              Post.includes(:user, :careers, comments: :user)
                  .for_career_ids(current_user.career_ids)
                  .most_recent
            else
              Post.none
            end

    @user_posts = current_user.posts.includes(:user, :careers).most_recent

    render :index, formats: :json
  end


  # GET /api/posts/:id
  def show
    render :show, formats: :json
  end

  # POST /api/posts
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      render json: @post.as_json(current_user: current_user), status: :created
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post.as_json(current_user: current_user)
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
    allowed = [:title, :content, :image, :user_slug, :created_at, :skill_id, career_ids: []]
    source = params[:post].present? ? params.require(:post) : params
    source = source.except(:format)
    source.permit(allowed)
  end

  def set_post
    @post = Post.includes(:comments).friendly.find(params[:id] || params[:slug])

    unless @post
      render json: { error: 'Post not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end
end
