class TicketsController < ApplicationController
  before_action :set_ticket, only: [:edit, :update, :destroy, :update_ticket]
  helper_method :sort_column, :sort_direction
  OPEN = 1
  ON_HOLD = 2
  CLOSE = 3
  USER = "User"

  # GET /tickets
  # GET /tickets.json
  def index
    @o_all = get_records(params[:page])
    
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @ticket = Ticket.where(:ticket_secret => params[:id].to_s).first
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
    unless current_user.present?
      # check user exsist
      if @user = User.find_by(:email => params[:user][:email])
        @user_exist = true
        params[:ticket][:user_id] = @user.id
        @user_session = UserSession.new(@user, true)            
        if @user_session.save
          session[:user_id] = @user.id
          session[:user_role] = @user.role.role_type     
        end        
      else
        @user_exist = false
        if params[:user][:email].present? 
          params[:user][:password] = params[:user][:password_confirmation] = SecureRandom.hex(8)
          params[:user][:registration_key] = SecureRandom.hex(25)
          params[:user][:term] = params[:user][:is_active] = 1
          
          @user = User.new(user_params)
          
          #user save
          if @user.save(:validate => false)
            @user.role = Role.find_by(:role_type => USER)
            #user session
            params[:user_session] = {}
            params[:user_session][:email] = params[:user][:email]
            params[:user_session][:password] = params[:user][:password]
            @user_session = UserSession.new(params[:user_session])            
            if @user_session.save
              session[:user_id] = @user.id
              session[:user_role] = @user.role.role_type     
            end
          end
        end        
      end
      
    else
      @user = current_user
      @user_exist = true
    end
    
    @ticket = Ticket.new(ticket_params)
    
    respond_to do |format|
      if @ticket.save
        @ticket.ticket_secret = SecureRandom.hex(5).to_s + @ticket.id.to_s
        @ticket.user_id = @user.id
        @ticket.save
        if @user_exist
          # send mail to user with ticket link
          opts = { 
            :ticket => @ticket,
            :ticket_status => ticket_status_hash[@ticket.status_id.to_s],
            :ticket_priority => ticket_priority_hash[@ticket.priority_id.to_s],
            :email => @user.email            
          }
          TicketMailer.new_ticket_email_with_user(@user.email, opts).deliver
        else
          # send mail to user with ticket link
          opts = { 
            :ticket => @ticket,
            :ticket_status => ticket_status_hash[@ticket.status_id.to_s],
            :ticket_priority => ticket_priority_hash[@ticket.priority_id.to_s],           
            :email => @user.email, 
            :password => params[:user][:password]            
          }
          TicketMailer.new_ticket_email_without_user(@user.email, opts).deliver            
        end        
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
      if params[:reply_close].present?
        @ticket.status_id = CLOSE
        @ticket.save
        flash[:success_reply] = "Ticket reply was successfully created and closed."
        redirect_to tickets_url
      else
        redirect_to ticket_url(@ticket.ticket_secret)  
      end
    else  
      flash[:notice_reply] = "Please enter reply."
      redirect_to ticket_url(@ticket.ticket_secret)
    end
  end
  
  def update_ticket
    @ticket.update(ticket_params)
    render nothing: true
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
      query = current_user.tickets.open_and_on_hold
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
