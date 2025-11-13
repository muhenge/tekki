module Api
  module Auth
    class SessionsController < Devise::Api::SessionsController
      # POST /api/auth/sign_in
      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        yield resource if block_given?

        render json: { success: true, user: resource }
      end

      # DELETE /api/auth/sign_out
      def destroy
        # Devise::Api::SessionsController handles token revocation automatically
        # The super call will handle signing out the user and revoking the token
        super
      end
    end
  end
end