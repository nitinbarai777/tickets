class TicketMailer < ActionMailer::Base
  default from: "from@example.com"
  
  # send ticket link
  def new_ticket_email(email, opts)
    @ticket_id = opts[:id]
    @ticket_subject = opts[:ticket_subject]
    @ticket_description = opts[:ticket_description]
    @email = opts[:ticket_email]
    mail(:to => "#{email}", :subject => "SupportEngine - Ticket##{@ticket_id} #{@ticket_subject}")
  end
  
end
