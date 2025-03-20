class Api::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by(id: params[:followed_id])

    if user.nil?
      return render json: { error: 'User not found' }, status: :not_found
    elsif current_user == user
      return render json: { error: 'You cannot follow yourself' }, status: :unprocessable_entity
    elsif current_user.following?(user)
      return render json: { message: 'You are already following this user' }, status: :ok
    end

    current_user.follow(user)
    render json: { message: 'Relationship created successfully', followed_user: user }, status: :created
  end

  def destroy
    relationship = current_user.active_relationships.find_by(id: params[:id])

    if relationship.nil?
      return render json: { error: 'Relationship not found' }, status: :not_found
    end

    relationship.destroy
    render json: { message: 'Relationship destroyed successfully', unfollowed_user: relationship.followed }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :avatar, :lastname, :email, :username, :about, :bio, :career_id, skills: [])
  end
end
