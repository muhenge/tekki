module Api
  module Auth
    class SessionsController < Devise::SessionsController
      respond_to :json
      before_action :ensure_json_request

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: {
                   message: "Logged in successfully.",
                   # token: request.env['warden-jwt_auth.token'],
                   data: current_user
                 },
                 status: :ok
        else
          render json: {
                   error: "Invalid email or password."
                 },
                 status: :unauthorized
        end
      end

      def respond_to_on_destroy
        jwt_payload =
          JWT.decode(
            request.headers["Authorization"].split(" ")[1],
            Rails.application.secret_key_base
          )
        current_user = User.find(jwt_payload[0]["sub"])
        return unless current_user

        render json: { message: "Logged out successfully." }, status: :ok
      end

      def logout_failure
        render json: { message: "Failed to logout!" }, status: :unauthorized
      end

      def ensure_json_request
        request.format = :json
      end
    end
  end
end
