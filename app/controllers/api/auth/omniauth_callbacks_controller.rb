module Api
  module Auth
    class OmniauthCallbacksController < Devise::OmniauthCallbacksController
      skip_before_action :verify_authenticity_token, raise: false
      before_action :set_origin, only: [:failure]

      def google_oauth2
        handle_oauth('google_oauth2')
      end

      def microsoft_office365
        handle_oauth('microsoft_office365')
      end

      def apple
        handle_oauth('apple')
      end

      def failure
        error_message = params[:message] || 'Authentication failed'
        redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/auth/failure?error=#{CGI.escape(error_message)}"
      end

      private

      def handle_oauth(provider_name)
        @user = User.find_or_create_from_oauth(request.env['omniauth.auth'], provider_name)

        if @user.persisted?
          sign_in_and_redirect(@user, event: :authentication)
          set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
        else
          session['devise.omniauth_data'] = request.env['omniauth.auth'].except('extra')
          redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/auth/failure?error=#{CGI.escape(@user.errors.full_messages.join(', '))}"
        end
      rescue StandardError => e
        Rails.logger.error "OmniAuth error: #{e.message}"
        redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/auth/failure?error=#{CGI.escape(e.message)}"
      end

      def set_origin
        session[:omniauth_origin] = params[:origin] if params[:origin]
      end

      def sign_in_and_redirect(resource, event: :authentication)
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name, resource)
        
        # Generate JWT token for API authentication
        token = resource.generate_jwt_token
        
        redirect_to "#{ENV.fetch('FRONTEND_URL', 'http://localhost:3000')}/auth/success?token=#{token}&user_id=#{resource.id}"
      end
    end
  end
end
