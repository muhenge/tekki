class ApplicationController < ActionController::API
  def current_token
    request.env['warden-jwt_auth.token']
  end
end
