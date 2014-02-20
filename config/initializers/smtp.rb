ActionMailer::Base.smtp_settings = {
  :address              => MAIL_ADDRESS,
  :port                 => MAIL_PORT,
  :domain               => MAIL_DOMAIN,
  :user_name            => MAIL_USER_NAME,
  :password             => MAIL_PASSWORD,
  :authentication       => "plain"
}