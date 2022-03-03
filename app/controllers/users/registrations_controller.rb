class Users::RegistrationsController < Devise::RegistrationsController

  #devise create user
  def create
    @user = User.new(sign_up_params)
    if @user.save
      render json: {success: true, user:@user, response: "Authentication successful" }, status: 201
    else
      render json: {success: false, response: @user.errors.full_messages }, status: 401
    end
  end
end
