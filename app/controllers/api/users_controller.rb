class Api::UsersController < ApplicationController
  before_action :set_user, only: %i[index show user_connections] 
  before_action :authenticate_user!

  def index
    @users = User.all.includes(:following,:followers,:skills,:career)
    render json: {
      success: true,
      users: @users,
    }, status: :ok
  end

  def show
    render json: {
      success:true,
      message:"User found",
      user:@user,
      career:@user.career,
      followers:@user.followers,
      following:@user.following,
      posts: @user.posts.limit(5),
      skills: @user.skills.limit(6)
    }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:avatar,:firstname, :avatar,:slug, :lastname, :email, :username, :about, :bio)
  end

  def set_user
    @user = params[:id] ? User.includes(:career,:followers,:following,:posts,:skills).friendly.find(params[:id]) : User.includes(:followers,:following,:posts).friendly.find_by_slug(params[:slug]) || current_user
  end
end
