class Users::SessionsController < Devise::SessionsController
  private

  def respond_with(resource, _opts = {})
  
    if resource.id != nil
      render json: { success: true, user: resource,token: current_token, response: 'Authentication successfully' }, status: 201
    else
      render json: { success: false, response: 'Invalid credentials! Verify again' }, status: 401
    end
  end
  
  def respond_to_on_destroy
    render json: { message: 'logged out successfully!', }
  end

end
