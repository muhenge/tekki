class Api::PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy vote]
  before_action :authenticate_user!, only: %i[index new edit update show destroy vote search]
  before_action :authenticate_user_or_guest!, only: %i[create]

  respond_to :json

  #
  def index
    career_ids = current_user.career_ids
    
    @posts = if career_ids.any?
              Post.includes(:user, :careers, comments: :user)
                  .for_career_ids(career_ids)
                  .where.not(user_id: current_user.id) # Exclude own posts from main feed
                  .most_recent
            else
              Post.none
            end

    @user_posts = current_user.posts.includes(:user, :careers).most_recent

    @users_with_same_careers = User.suggested_for(current_user)
                                   .limit(5)
                                   .includes(:careers)
                                   .with_attached_avatar

    render :index, formats: :json
  end


  # GET /api/posts/search
  def search
    @posts = Post.includes(:user, :careers, comments: :user).most_recent
    @posts = @posts.search_by_title(params[:query]) if params[:query].present?
    
    career_ids = params[:career_ids] || params[:career_id]
    @posts = @posts.for_career_ids(career_ids) if career_ids.present?

    @user_posts = [] # Empty for search results
    render :index, formats: :json
  end


  # GET /api/posts/:id
  def show
    render :show, formats: :json
  end

  # POST /api/posts
  def create
    @post = @current_user_or_guest.posts.build(post_params)

    if @post.save
      render json: @post.as_json(current_user: @current_user_or_guest), status: :created
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.user == current_user
      if @post.update(post_params)
        render json: @post.as_json(current_user: current_user)
      else
        render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not authorized' }, status: :forbidden
    end
  end

  def destroy
    if @post.user == current_user
      if @post.destroy
        head :no_content
      else
        render json: { error: 'Failed to delete post' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not authorized' }, status: :forbidden
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

  def authenticate_user_or_guest!
    if user_signed_in?
      @current_user_or_guest = current_user
    elsif params[:guest_email].present?
      @current_user_or_guest = User.find_by(email: params[:guest_email])
      
      if @current_user_or_guest&.member?
        render json: { error: 'This email is registered. Please log in to post.' }, status: :unauthorized
        return
      end

      unless @current_user_or_guest
        @current_user_or_guest = User.new(
          email: params[:guest_email],
          role: :guest,
          password: SecureRandom.hex(16)
        )
        
        # Split name into first and last if possible, or just use as username
        guest_name = params[:guest_name] || params[:guest_email].split('@').first
        @current_user_or_guest.firstname = guest_name.split(' ').first
        @current_user_or_guest.lastname = guest_name.split(' ', 2).last if guest_name.include?(' ')
        @current_user_or_guest.username = "guest_#{SecureRandom.hex(4)}"
        
        unless @current_user_or_guest.save
          render json: { error: @current_user_or_guest.errors.full_messages }, status: :unprocessable_entity
          return
        end
      end
    else
      authenticate_user!
    end
  end

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
