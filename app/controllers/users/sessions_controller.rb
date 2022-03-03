class Users::SessionsController < Devise::SessionsController
  private

  def respond_with(resource, _opts = {})
    render json: { 
      success: true,
      user: resource,
      message: 'You are logged in.' ,
      token: current_token,
      }, status: :ok
  end

  def respond_to_on_destroy
    render json: { message: 'logged out successfully!', }
  end

end
