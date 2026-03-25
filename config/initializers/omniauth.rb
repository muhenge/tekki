Rails.application.config.middleware.use OmniAuth::Builder do
  # Google OAuth2
  provider :google_oauth2,
           ENV.fetch('GOOGLE_CLIENT_ID', nil),
           ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
           {
             scope: 'email,profile',
             prompt: 'select_account',
             image_aspect_ratio: 'square',
             access_type: 'offline',
             skip_jwt_bearer_tokens: true
           }

  # Microsoft Office 365
  provider :microsoft_office365,
           ENV.fetch('MICROSOFT_CLIENT_ID', nil),
           ENV.fetch('MICROSOFT_CLIENT_SECRET', nil),
           {
             scope: 'User.Read openid profile email',
             tenant: 'common'
           }

  # Apple
  provider :apple,
           ENV.fetch('APPLE_CLIENT_ID', nil),
           ENV.fetch('APPLE_CLIENT_SECRET', nil),
           {
             scope: 'name email',
             response_type: 'code',
             response_mode: 'form_post'
           }
end

# Configure OmniAuth URL path prefix
OmniAuth.config.path_prefix = '/api/auth'

# Allow test mode in development
OmniAuth.config.test_mode = Rails.env.test?

# Configure logger for debugging
OmniAuth.config.logger = Rails.logger
