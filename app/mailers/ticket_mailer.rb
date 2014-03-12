class TicketMailer < ActionMailer::Base
  include ApplicationHelper
  
  default from: "from@example.com"
  
  # send ticket link
  def new_ticket_email_without_user(email, opts)
    @ticket = opts[:ticket]
    @email = opts[:email]
    @password = opts[:password]
    @priority = ticket_priority_hash[@ticket.priority_id.to_s]
    @status = ticket_status_hash[@ticket.status_id.to_s]
    mail(:to => "#{email}", :subject => "SupportEngine - Ticket##{@ticket.ticket_secret} #{@ticket.subject}")
  end
  
  def new_ticket_email_with_user(email, opts)
    @ticket = opts[:ticket]
    @email = opts[:email]
    @password = opts[:password]
    @priority = ticket_priority_hash[@ticket.priority_id.to_s]
    @status = ticket_status_hash[@ticket.status_id.to_s]
    mail(:to => "#{email}", :subject => "SupportEngine - Ticket##{@ticket.ticket_secret} #{@ticket.subject}")
  end  
  
end
