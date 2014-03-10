class Admin::DashboardController < ApplicationController
  before_action :require_admin
  
  def index
    #return render text: Ticket.group(:user_id).count
    #return render text: Ticket.open.where("DATE(created_at) = ?", Date.today).to_sql
  end
end
