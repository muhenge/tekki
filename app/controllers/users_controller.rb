class UsersController < ApplicationController
  before_action :set_user, only: %i[index show user_connections] 
  before_action :authenticate_user!

  def index
    @users = User.all.includes(:following,:followers)
    render json: {
      users:@users
    }
  end

  def user_connections
    @user_following = current_user.following
    @user_follow = current_user.followers
  end

  def show
    @user_following = @user.following
    @user_follow = @user.followers 
    @skill = Skill.new
    @user_skills = @user.skills
    @user_posts = @user.posts.most_recent.limit(5)
  end

  private

  def user_params
    params.require(:user).permit(:avatar,:firstname, :avatar,:slug, :lastname, :email, :username, :about, :bio, :career_id, skills:[])
  end

  def set_user
    @user = params[:id] ? User.friendly.find(params[:id]) : User.friendly.find_by_slug(params[:slug]) || current_user
  end
end
