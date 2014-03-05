class TicketMailer < ActionMailer::Base
  default from: "from@example.com"
  
  # send ticket link
  def new_ticket_email(email, opts)
    @ticket_id = opts[:id]
    @ticket_subject = opts[:ticket_subject]
    mail(:to => "#{email}", :subject => "#{@ticket_subject}")
  end
  
end
