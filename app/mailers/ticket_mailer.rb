class TicketMailer < ActionMailer::Base
  default from: "from@example.com"
  
  # send ticket link
  def new_ticket_email_without_user(email, opts)
    @ticket = opts[:ticket]
    @ticket_status = opts[:ticket_status]
    @ticket_priority = opts[:ticket_priority]
    @email = opts[:email]
    @password = opts[:password]
    mail(:to => "#{email}", :subject => "SupportEngine - Ticket##{@ticket.ticket_secret} #{@ticket.subject}")
  end
  
  def new_ticket_email_with_user(email, opts)
    @ticket = opts[:ticket]
    @ticket_status = opts[:ticket_status]
    @ticket_priority = opts[:ticket_priority]    
    @email = opts[:email]
    mail(:to => "#{email}", :subject => "SupportEngine - Ticket##{@ticket.ticket_secret} #{@ticket.subject}")
  end  
  
end
