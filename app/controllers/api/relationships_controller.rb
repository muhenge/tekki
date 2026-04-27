class Api::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    identifier = params[:slug] || params[:followed_id] || params[:id]
    user = User.friendly.find(identifier)

    if user.nil?
      return render json: { error: 'User not found' }, status: :not_found
    elsif current_user == user
      return render json: { error: 'You cannot follow yourself' }, status: :unprocessable_entity
    elsif current_user.following?(user)
      return render json: { 
        message: 'You are already following this user', 
        followed_user: user,
        relationship_id: user.relationship_id_for(current_user)
      }, status: :ok
    end

    current_user.follow(user)
    render json: { 
      message: 'Relationship created successfully', 
      followed_user: user,
      relationship_id: user.relationship_id_for(current_user)
    }, status: :created
  end

  def destroy
    # Try finding user by slug/id from nested route first
    identifier = params[:slug] || params[:id]
    user = User.friendly.find_by(slug: identifier) || User.find_by(id: identifier)

    relationship = if user
                     current_user.active_relationships.find_by(followed_id: user.id)
                   else
                     # Fallback to finding relationship by its own ID (legacy)
                     current_user.active_relationships.find_by(id: params[:id])
                   end

    if relationship.nil?
      return render json: { error: 'Relationship not found' }, status: :not_found
    end

    relationship.destroy
    render json: { 
      message: 'Relationship destroyed successfully', 
      unfollowed_user: relationship.followed 
    }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :avatar, :lastname, :email, :username, :about, :bio, :career_id, skills: [])
  end
end
