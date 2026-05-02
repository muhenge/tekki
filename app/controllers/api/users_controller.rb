module Api
  class UsersController < ApplicationController

    before_action :set_user, only: %i[show update destroy]
    before_action :authenticate_user!, only: %i[show update destroy]

    def index
      users = User.member
                  .includes(:following, :followers, :skills, :careers)
                  .page(params[:page])
                  .per(params[:per_page] || 10)

      render json: {
        success: true,
        users: users,
        meta: pagination_meta(users)
      }, status: :ok
    end

    def update
      if @user.update(user_params)
        render json: { success: true, user: @user }, status: :ok
      else
        render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      if @user
        render json: { success: true, message: 'User found', user: user_response(@user) }, status: :ok
      else
        render json: { success: false, message: 'User not found' }, status: :not_found
      end
    end

    def user_connections
      user = User.friendly.find(params[:slug] || params[:id])
      
      followers = user.followers.map do |f|
        {
          userId: f.id,
          username: f.username,
          slug: f.slug,
          relationshipId: f.relationship_id_for(current_user),
          isFollowing: current_user&.following?(f),
          redirectTo: "/profile/#{f.slug}"
        }
      end

      following = user.following.map do |f|
        {
          userId: f.id,
          username: f.username,
          slug: f.slug,
          relationshipId: f.relationship_id_for(current_user),
          isFollowing: true,
          redirectTo: "/profile/#{f.slug}"
        }
      end

      render json: {
        success: true,
        followers: followers,
        following: following
      }
    rescue ActiveRecord::RecordNotFound
      render json: { success: false, error: 'User not found' }, status: :not_found
    end

  private

    def user_response(user)
      {
        user: user.as_json(
          only: %i[id email username firstname lastname slug bio about created_at updated_at]
        ),
        careers: user.careers.map { |career| career.as_json(only: %i[id field]) },
        followers_count: user.followers.count,
        following_count: user.following.count,
        posts_count: user.posts.count,
        skills_count: user.skills.count,
        followers: user.followers.as_json(only: %i[id username slug]),
        following: user.following.as_json(only: %i[id username slug]),
        posts: user.posts.limit(5).as_json(only: %i[id title content author slug created_at]),
        skills: user.skills.limit(6).as_json(only: %i[id name user_slug])
      }
    end

    def user_params
      params.require(:user).permit(:avatar, :firstname, :slug, :lastname, :email, :username, :about, :bio)
    end

    def set_user
      @user = if params[:id]
                User.includes(:careers, :followers, :following, :posts, :skills).friendly.find(params[:id])
              else
                User.includes(:careers, :followers, :following, :posts, :skills).friendly.find_by(slug: params[:slug]) || current_user
              end
    end

    def pagination_meta(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    end
  end
end
