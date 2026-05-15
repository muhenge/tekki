class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_active_storage_url_options

  def current_token
    request.env['warden-jwt_auth.token']
  end

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: request.base_url }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
    keys: [:username, :firstname, :lastname, :bio, :about, { career_ids: [] }]
  )
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :firstname, :lastname, :username, :about, :bio, { career_ids: [] }, { skills: [] }])
  end
end
