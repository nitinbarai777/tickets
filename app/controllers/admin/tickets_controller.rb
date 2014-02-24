class Admin::TicketsController < ApplicationController
  before_action :set_admin_ticket, only: [:show, :edit, :update, :destroy]

  # GET /admin/tickets
  # GET /admin/tickets.json
  def index
    @o_all = Ticket.all
  end

  # GET /admin/tickets/1
  # GET /admin/tickets/1.json
  def show
    if @ticket.present?
      @ticket_replies = @ticket.ticket_replies
      @ticket_reply = TicketReply.new
    end
  end

  # GET /admin/tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /admin/tickets/1/edit
  def edit
  end

  # POST /admin/tickets
  # POST /admin/tickets.json
  def create
    @ticket = Ticket.new(admin_ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to admin_ticket_url(@ticket.id), notice: 'Ticket was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ticket }
      else
        format.html { render action: 'new' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tickets/1
  # PATCH/PUT /admin/tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(admin_ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tickets/1
  # DELETE /admin/tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to admin_tickets_url, notice: 'Ticket delete successfully.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_ticket_params
      params.require(:ticket).permit!
    end
end
