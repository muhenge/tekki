module Api
  module Auth
    class RegistrationsController < Devise::Api::RegistrationsController
      def create
        build_resource(sign_up_params)

        resource.career_ids = params[:user][:career_ids] if params[:user][:career_ids].present?

        if resource.save
          yield resource if block_given?
          if resource.persisted?
            render json: {
              success: true,
              user: resource,
              message: "Registration successful"
            }, status: :created
          else
            render json: {
              success: false,
              errors: format_errors(resource.errors)
            }, status: :unprocessable_entity
          end
        else
          render json: {
            success: false,
            errors: format_errors(resource.errors)
          }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(account_update_params)
          render json: {
                   success: true,
                   user: @user,
                   message: "Profile updated successfully"
                 },
                 status: :ok
        else
          render json: {
                   success: false,
                   errors: format_errors(@user.errors)
                 },
                 status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username, :firstname, :lastname, :bio, career_ids: [])
      end

      def account_update_params
        params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :username, :firstname, :lastname, :bio, career_ids: [])
      end

      def format_errors(errors)
        errors.to_hash(true).transform_values { |v| v.join(", ") }
      end
    end
  end
end
