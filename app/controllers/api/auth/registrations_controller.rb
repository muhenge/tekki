module Api
  module Auth
    class RegistrationsController < Devise::RegistrationsController
      def create
        @user = User.new(sign_up_params)

        if @user.save
          # @user.sign_in(@user)
          @user.generate_login_token!
          UserMailer.with(user: @user).login_token_email.deliver_later
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
        if @user.update(sign_up_params)
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

      def format_errors(errors)
        errors.to_hash(true).transform_values { |v| v.join(", ") }
      end
    end
  end
end
