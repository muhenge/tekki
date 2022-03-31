class Api::PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update edit destroy vote]
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :show, :destory, :vote]
  respond_to :json

  swagger_controller :posts, 'Posts'

  swagger_api :index do
    summary 'Returns all posts'
    notes 'Notes...'
  end
  
  def index
    posts = Post.all.includes(:user, :comments, :career).most_recent
    render json: {
      posts:posts
    }
  end
  def show
    render json: {
      post: @post,
      comments: @post.comments
    }
  end
  def create
    @post = current_user.posts.build(post_params)
    if  @post.save
      render json: {
        post: @post,
        message: 'Post created successifully'
      }, status: :created
    else
     render json: {
       error: @post.errors.full_messages
     }
    end
  end

  def update
    @post.update(post_params)
    render json: {
      message:"Updated successfully",
      post:@post
    }
  end

  def vote
    if !current_user.liked? @post
      @post.liked_by current_user
      render json: {
        message:"Post liked"
      }
    elsif current_user.liked? @post
      @post.unliked_by current_user
      render json: {
        message:"Post liked failed"
      }
    end
  end


  private
  def post_params
    params.require(:post).permit(:title,:content, :image,:user_slug, :created_at, :skill_id, :career_id)
  end

  def set_post
    @post = Post.includes(:comments).find(params[:id])
  end
end
