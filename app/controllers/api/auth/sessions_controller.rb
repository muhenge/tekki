module Api
  module Auth
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: {
            message: 'Logged in successfully.',
            # token: request.env['warden-jwt_auth.token'],
            data: current_user
          }, status: :ok
        else
          render json: { error: 'Invalid email or password.' }, status: :unauthorized
        end
      end

      def respond_to_on_destroy

      end


      def logout_failure
        render json: { message: 'Failed to logout!' }, status: :unauthorized
      end
    end
  end
end