module Api
  module Auth
    class AuthStatusController < ApplicationController
      before_action :authenticate_user!

      def check
        if user_signed_in?
          render json: {
            success: true,
            user: current_user.as_json(only: [:id, :email, :username, :firstname, :lastname, :slug, :role, :bio, :about]).merge(
              avatar_url: current_user.avatar_url
            )
          }, status: :ok
        else
          render json: { success: false, error: "Not authenticated" }, status: :unauthorized
        end
      end
    end
  end
end
