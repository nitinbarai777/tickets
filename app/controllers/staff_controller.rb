class StaffController < ApplicationController
  before_action :require_staff
  
  def tickets
    @tickets = Ticket.active.open.all  
  end
  
  def ticket_reply
    ticket_id = params[:id]

    if ticket_id.present?
      @ticket = Ticket.find(ticket_id)
      @ticket_replies = @ticket.ticket_replies
      @ticket_reply = TicketReply.new
    end
  end
  
  def ticket_reply_create
    @ticket = Ticket.find(params[:ticket_reply][:ticket_id])
    @ticket_replies = @ticket.ticket_replies
    @ticket_reply = TicketReply.new(ticket_reply_params)
    if @ticket_reply.save
      flash[:notice] = t("Ticket reply was successfully created.")
    end

    #respond_to do |format|
    #  if @ticket_replies.save
    #    format.html { redirect_to staff_tickets_url, notice: 'Ticket reply was successfully created.' }
    #    #format.json { render action: 'show', status: :created, location: @ticket }
    #  else
    #    format.html { render action: 'ticket_reply' }
    #    format.json { render json: @ticket_replies.errors, status: :unprocessable_entity }
    #  end
    #end
  end
  
  private
    def ticket_reply_params
      params.require(:ticket_reply).permit!
    end
end
