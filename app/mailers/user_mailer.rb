class UserMailer < ApplicationMailer
  def login_token_email
    @user = params[:user]
    @login_url = "http://localhost:3000/magic_login?token=#{@user.login_token}"
    mail(to: @user.email, subject: 'Your login link')
  end
end
