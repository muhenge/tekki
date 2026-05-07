module Api
  class UsersController < ApplicationController

    before_action :set_user, only: %i[show update destroy upload_avatar]
    before_action :authenticate_user!, only: %i[show update destroy upload_avatar]

    def index
      if current_user
        users = User.member
                .includes(:following, :followers, :skills, :careers)
                .page(params[:page])
                .per(params[:per_page] || 10)
      else
        users = User.publicly_visible.member
                .includes(:following, :followers, :skills, :careers)
                .page(params[:page])
                .per(params[:per_page] || 10)
      end

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

    def upload_avatar
      if params[:avatar].present?
        @user.avatar.attach(params[:avatar])
        if @user.save
          render json: {
            success: true,
            message: 'Avatar uploaded successfully',
            avatar_url: @user.avatar.url
          }, status: :ok
        else
          render json: {
            success: false,
            errors: @user.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        render json: {
          success: false,
          message: 'No avatar provided'
        }, status: :bad_request
      end
    end

    def show
      Rails.logger.info "User found:  Avatar: #{@user.avatar.attached? ? @user.avatar.url : 'No avatar'}"

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
        avatar_url: user.avatar.attached? ? user.avatar.url : nil,
        careers: user.careers.map { |career| career.as_json(only: %i[id field]) },
        followers_count: user.followers.count,
        public_profile: user.public_profile,
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
      params.require(:user).permit(:avatar_url, :firstname, :slug, :lastname, :email, :username, :about, :bio, :public_profile)
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
