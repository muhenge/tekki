class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    user = User.find_by_email(sign_in_params[:email])
    if user && user.valid_password?(sign_in_params[:password])
      render json: {message: 'Logged in successifully.', token: current_token, data: user }, status: :ok
    else
      render json: {error: 'Invalid email or password.'}, status: :unauthorized
    end
    
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
