class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update edit destroy vote]
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :show, :destory, :vote]
  respond_to :json
  def index
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

  def show
  end

  private
  def post_params
    params.require(:post).permit(:title,:content)
  end


  def set_post
    @post = Post.find(params[:id])
  end
end
