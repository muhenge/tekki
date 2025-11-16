module Api
  module Auth
    class TokensController < ApplicationController
      # POST /api/auth/refresh
      def create
        refresh_token =
          cookies.encrypted[:refresh_token] || params[:refresh_token]
        unless refresh_token
          return(
            render json: {
                     success: false,
                     error: "Missing refresh token"
                   },
                   status: :bad_request
          )
        end

        record = RefreshToken.find_by(token: refresh_token)
        unless record&.valid_token?
          return(
            render json: {
                     success: false,
                     error: "Invalid refresh token"
                   },
                   status: :unauthorized
          )
        end

        user = record.user

        # rotate: revoke old and create new
        ActiveRecord::Base.transaction do
          record.revoke!
          new_refresh = RefreshToken.create_for_user(user)
          # build new access token payload (must include jti if using JTIMatcher)
          payload = {
            sub: user.id,
            email: user.email,
            jti: user.jti,
            iat: Time.current.to_i,
            exp: 15.minutes.from_now.to_i
          }
          new_access =
            JWT.encode(payload, ENV["DEVISE_JWT_SECRET_KEY"], "HS256")

          # set cookies
          cookies.encrypted[:access_token] = {
            value: new_access,
            httponly: true,
            secure: Rails.env.production?,
            same_site: :Strict,
            expires: 15.minutes.from_now
          }
          cookies.encrypted[:refresh_token] = {
            value: new_refresh.token,
            httponly: true,
            secure: Rails.env.production?,
            same_site: :Strict,
            expires: 30.days.from_now
          }
        end

        render json: { success: true }, status: :ok
      rescue => e
        Rails.logger.error "Refresh error: #{e.message}"
        render json: {
                 success: false,
                 error: "Refresh failed"
               },
               status: :unauthorized
      end
    end
  end
end
