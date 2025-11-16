module Api
  module Auth
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      before_action :authenticate_user!, only: %i[update destroy]

      def create
        user_params = sign_up_params.to_h.deep_symbolize_keys
        career_ids_or_names = user_params.delete(:career_ids)

        @user = User.new(user_params)

        if @user.save
          if career_ids_or_names.present?
            careers = career_ids_or_names.map do |item|
              if item.is_a?(Integer) || item.match?(/\A\d+\z/)
                Career.find_by(id: item.to_i)
              elsif item.is_a?(String)
                Career.find_or_create_by(field: item)
              end
            end.compact
            @user.careers = careers
          end

          sign_in(@user)
          Rails.logger.info "User signed in successfully."
          # @user.generate_login_token!
          # UserMailer.with(user: @user).login_token_email.deliver_later

          render json: {
                   success: true,
                   user: @user,
                   message: "Registration successful"
                 },
                 status: :created
        else
          render json: {
                   success: false,
                   errors: format_errors(@user.errors)
                 },
                 status: :unprocessable_entity
        end
      end

      def update
        if @user.update_with_password(account_update_params)
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

      def destroy
        @user.destroy
        render json: {
                 success: true,
                 message: "Account deleted successfully"
               },
               status: :ok
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username, :first_name, :last_name, career_ids: [])
      end

      def account_update_params
        params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :username, :first_name, :last_name, career_ids: [])
      end

      def format_errors(errors)
        errors.to_hash(true).transform_values { |v| v.join(", ") }
      end
    end
  end
end
