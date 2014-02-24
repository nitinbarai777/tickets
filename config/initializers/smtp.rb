ActionMailer::Base.smtp_settings = {
  :address              => Tickets::MAIL_ADDRESS,
  :port                 => Tickets::MAIL_PORT,
  :domain               => Tickets::MAIL_DOMAIN,
  :user_name            => Tickets::MAIL_USER_NAME,
  :password             => Tickets::MAIL_PASSWORD,
  :authentication       => "plain"
}
