class ConfirmationMailer < Devise::Mailer
  #helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts={})
    # Customize the confirmation email
    @token = token
    @resource = record
    @sign_in_url = new_user_session_url

    # Set custom subject
    mail(to: record.email, subject: 'Confirm your account') do |format|
      format.html { render "custom_confirmation_instructions" }
    end
  end
end
