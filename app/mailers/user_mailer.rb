class UserMailer < ActionMailer::Base
  #default from: ProjectApp::DEFAULT_MAIL_FROM
  default :from => "noreply@projectapp.com"

  # new user registration 
  def registration_confirmation(email, opts)
    @username = opts[:username]
    @registration_key = opts[:registration_key]
    @email = opts[:email]
    @password = opts[:password]
    @application = t("general.app_title")
    mail(:to => "#{email}", :subject => t("mail.registration_confirmation.confirm_your_email_to_start"))
  end

  # forgot password
  def forgot_password_confirmation(email, subject, opts)
    @username = opts[:username]
    @new_pass = opts[:new_pass]
    @application = t("general.app_title")
    mail(:to => "#{email}", :subject => subject, :content_type => "text/html")
  end
end
