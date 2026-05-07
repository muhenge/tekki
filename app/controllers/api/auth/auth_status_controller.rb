module Api
  module Auth
    class AuthStatusController < ApplicationController
      before_action :authenticate_user!

      def check
        Rails.logger.info ".............................start checking........................................."
        Rails.logger.info "Current user: #{current_user.avatar.attached? ? current_user.avatar.url : 'No avatar'}"
        # Rails.logger.info "Session: #{session.inspect}"
        # # Rails.logger.info "Cookies: #{cookies.to_hash}"
        # Rails.logger.info "Request headers: #{request.headers.inspect}"
        if user_signed_in?
          render json: { user: current_user, avatar_url: current_user.avatar.url }, status: :ok
        else
          render json: { error: "Not authent,lollicated" }, status: :unauthorized
        end
      end
    end
  end
end
