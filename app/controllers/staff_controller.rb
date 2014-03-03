class StaffController < ApplicationController
  before_action :require_staff
  helper_method :sort_column, :sort_direction
  OPEN = 1
  CLOSE = 2  
  
  
  def tickets
    session[:search_params] = params[:user] ? params[:user] : nil

    session[:set_pager_number] = params[:set_pager_number] if params[:set_pager_number]

    if session[:set_pager_number].nil?
      session[:set_pager_number] = 10
    end
        
    @tickets = Ticket.active.order(sort_column + " " + sort_direction).
                  paginate(:per_page => 20, :page => params[:page])  
  end
  
  def ticket_reply
    ticket_id = params[:id]

    if ticket_id.present?
      @ticket = Ticket.find(ticket_id)
      @ticket_replies = @ticket.ticket_replies.order(id: :desc)
      @ticket_reply = TicketReply.new
    end
  end
  
  def ticket_reply_create
    @ticket = Ticket.find(params[:ticket_reply][:ticket_id])
    @ticket_replies = @ticket.ticket_replies.order(id: :desc)
    @ticket_reply = TicketReply.new(ticket_reply_params)
    if @ticket_reply.save
      flash[:success_reply] = "Ticket reply was successfully created."
      if params[:reply_close]
        @ticket.status_id = CLOSE
        @ticket.save
        flash[:success_reply] = "Ticket reply was successfully created and closed."
      end      
      
    else  
      flash[:notice_reply] = "Please enter reply."
    end

  end
  
  private
    def ticket_reply_params
      params.require(:ticket_reply).permit!
    end
    
    def sort_column
      Ticket.column_names.include?(params[:sort]) ? params[:sort] : "status_id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end    
end
