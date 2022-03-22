class UsersController < ApplicationController
  before_action :set_user, only: %i[index show user_connections] 
  before_action :authenticate_user!

  def index
    @users = User.all.includes(:following,:followers,:skills,:career)
    render json: {
      users:@users
    }
  end

  def user_connections
    @user_following = current_user.following
    @user_follow = current_user.followers
  end

  def show
    render json: {
      user:@user,
      followers:@user.followers,
      following:@user.following,
      posts:@user.posts
    }
  end

  private

  def user_params
    params.require(:user).permit(:avatar,:firstname, :avatar,:slug, :lastname, :email, :username, :about, :bio, :career_id, skills:[])
  end

  def set_user
    @user = params[:id] ? User.includes(:followers,:following,:posts).friendly.find(params[:id]) : User.includes(:followers,:following,:posts).friendly.find_by_slug(params[:slug]) || current_user
  end
end
