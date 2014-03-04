class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  OPEN = 1
  CLOSE = 2
  USER = "User"

  # GET /tickets
  # GET /tickets.json
  def index
    @o_all = get_records(params[:page])
    
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    if @ticket.present?
      @ticket_replies = @ticket.ticket_replies.order(id: :desc)
      @ticket_reply = TicketReply.new
    end
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    #return render text: params
    
    unless current_user.present?
      params[:user][:password] = SecureRandom.hex(8)
      
      @user = User.new(user_params)
      
      @user.save(:validate => false)
        
      @user.role = Role.find_by(:role_type => USER)
      
      params[:ticket][:user_id] = @user.id
      
    end
    
    @ticket = Ticket.new(ticket_params)
    
    respond_to do |format|
      if @ticket.save
        unless current_user.present?
          format.html { redirect_to login_url, notice: 'Ticket was successfully created.' }
        else
          format.html { redirect_to tickets_url, notice: 'Ticket was successfully created.' }
        end
        format.json { render action: 'show', status: :created, location: @ticket }
      else
        format.html { render action: 'new' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to tickets_url, notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url }
      format.json { head :no_content }
    end
  end

  def reply_create
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
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit!
    end

    def ticket_reply_params
      params.require(:ticket_reply).permit!
    end
    
    def get_records(page)
      query = current_user.tickets.open
      query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
    end
    
    def sort_column
      Ticket.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
    
    def user_params
      params.require(:user).permit!
    end

end
