class UserMailer < ApplicationMailer
  def login_token_email
    @user = params[:user]
    @login_url = "#{root_url}api/auth/login?token=#{@user.login_token}"
    mail(to: @user.email, subject: "Your login token")
  end
end
