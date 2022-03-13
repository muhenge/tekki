class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    user = User.find_by_email(sign_in_params[:email])
    render json: {user: user, token: current_token, message: 'Logged in successifully.' }, status: :ok
  end

  def respond_to_on_failure(resource)
    render json: {error: resource.errors.full_messages.join(', ')}, status: :unprocessable_entity
  end

  def respond_to_on_destroy
    logout_success && return if current_user

    logout_failure
  end

  def logout_success
    render json: { message:"Logged out!" }, status: :ok
  end
  def logout_failure
    render json: { message:"Failed to logout!" }, status: :unauthorized
  end
end
