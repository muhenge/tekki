module Api
  module Auth
    class AuthStatusController < ApplicationController
      before_action :authenticate_user!

      def check
        Rails.logger.info ".............................start checking........................................."
        Rails.logger.info "Current user: #{current_user}"
        Rails.logger.info "Session: #{session.inspect}"
        Rails.logger.info "Cookies: #{cookies.inspect}"
        Rails.logger.info "Request headers: #{request.headers.inspect}"
        if user_signed_in?
          render json: { user: current_user }, status: :ok
        else
          render json: { error: "Not authenticated" }, status: :unauthorized
        end
      end
    end
  end
end
