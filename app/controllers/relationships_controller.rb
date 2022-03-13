class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    
    respond_to do |format|
        format.html { redirect_back fallback_location: users_path(@user) }
        format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        respond_to do |format|
            format.html { redirect_back fallback_location: user_path(@user) }
            format.js
        end
  end
  private

    def user_params
        params.require(:user).permit(:firstname,:avatar, :lastname, :email, :username, :about, :bio, :career_id, skills:[])
    end


    def set_user
        @user = User.find(params[:id])
    end 
end
