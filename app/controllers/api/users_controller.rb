module Api
  class UsersController < ApplicationController

    before_action :set_user, only: %i[show update destroy]
    before_action :authenticate_user!, only: %i[show, update, destroy]
    def index
      users = User.includes(:following, :followers, :skills, :career)
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

  private

    def user_response(user)
      Rails.cache.fetch("user_#{user.id}_response", expires_in: 1.hour) do
        {
          user: user,
          career: user.career,
          followers: user.followers,
          following: user.following,
          posts: user.posts.limit(5),
          skills: user.skills.limit(6)
        }
      end
    end

    def user_params
      params.require(:user).permit(:avatar, :firstname, :slug, :lastname, :email, :username, :about, :bio)
    end

    def set_user
      @user = if params[:id]
                User.includes(:career, :followers, :following, :posts, :skills).friendly.find(params[:id])
              else
                User.includes(:followers, :following, :posts).friendly.find_by(slug: params[:slug]) || current_user
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
