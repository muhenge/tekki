class ApplicationController < ActionController::Base
  include InertiaRails
  helper InertiaRails::Helpers

  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_token
    request.env['warden-jwt_auth.token']
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
    keys: [:username, :firstname, :lastname, :bio, :about, { career_ids: [] }]
  )
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :firstname, :lastname, :username, :about, :bio, { career_ids: [] }, { skills: [] }])
  end
end
