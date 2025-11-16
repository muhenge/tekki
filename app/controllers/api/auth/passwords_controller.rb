module Api
  module Auth
    class PasswordsController < Devise::PasswordsController
      respond_to :json

      # POST /api/auth/password
      def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)
        yield resource if block_given?

        if successfully_sent?(resource)
          render json: { success: true, message: "Password reset instructions sent successfully." }, status: :ok
        else
          render json: { success: false, errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/auth/password
      def update
        self.resource = resource_class.reset_password_by_token(resource_params)
        yield resource if block_given?

        if resource.errors.empty?
          resource.unlock_access! if unlockable?(resource)
          render json: { success: true, message: "Password changed successfully." }, status: :ok
        else
          render json: { success: false, errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def resource_params
        params.require(:user).permit(:email, :reset_password_token, :password, :password_confirmation)
      end
    end
  end
end
