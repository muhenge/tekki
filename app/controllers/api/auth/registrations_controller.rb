module Api
  module Auth
  class RegistrationsController < Devise::RegistrationsController

  def create

    @user = User.new(sign_up_params)

    if @user.save
      render json: {success: true, user:@user, response: "Authentication successfully" }, status: 201
    else
      render json: {success: false, response: @user.errors.full_messages }, status: 401
    end
  end
  def update
    if @user.update(sign_up_params)
      render json: {success: true, user:@user, response: "Updated successfully" }, status: 201
    else
      render json: {success: false, response: @user.errors.full_messages }, status: 401
    end
  end
  end
  end
end
