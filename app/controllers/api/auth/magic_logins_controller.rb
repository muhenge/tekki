module Api
  module Auth
    class MagicLoginsController < ApplicationController
      def show
        user = User.find_by(login_token: params[:token])

        if user && user.login_token_sent_at > 15.minutes.ago
          # Sign them in or issue token (e.g., JWT)
          render json: {
                   success: true,
                   user: user,
                   message: "Logged in successfully"
                   # Add token: user.generate_jwt if using JWT
                 }
        else
          render json: {
                   success: false,
                   error: "Invalid or expired token"
                 }, status: :unauthorized
        end
      end
    end
  end
end
