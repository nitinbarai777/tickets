class UserSessionsController < ApplicationController
  before_action :require_company, :except => [:new, :create, :destroy, :admin_login]
  # GET /user_sessions
  def index
    redirect_to new_user_session_path
  end

  # GET login
  def new
    if current_user
      redirect_to root_path
    else 
      if request.path == "/login" and @current_company.nil?
        redirect_to root_path
      else 
        @user_session = UserSession.new
        respond_to do |format|
          format.html # new.html.erb
          format.xml { render :xml => @user_session }
        end
      end  
    end
  end
  
  def admin_login
    if current_user
      redirect_to root_path
    else
      if request.post?  
        @user_session = UserSession.new(params[:user_session])
        
          if @user_session.save
            if current_user and current_user.is_active and current_user.role.role_type == "SuperAdmin"
              session[:user_id] = current_user.id
              session[:user_role] = current_user.role.role_type
              notice = t("general.login_successful")
              redirect_to admin_users_url
            else
              render text: current_user
              reset_session
              @user_session.destroy
              @user_session = UserSession.new
              flash[:error] = t("general.you_are_not_active_user")
              #render :action => "admin_login"
            end
          else
            reset_session
            @user_session.destroy
            @user_session = UserSession.new
            render :action => "admin_login"
          end
              
      else
        @user_session = UserSession.new
        respond_to do |format|
          format.html # new.html.erb
          format.xml { render :xml => @user_session }
        end
      end    
    end    
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        if current_user.is_active
          session[:user_id] = current_user.id
          session[:user_role] = current_user.role.role_type
          notice = t("general.login_successful")
          
          if is_admin?
            d_path = admin_users_url
          else 
            if @current_company
              if is_company_admin?
                d_path = users_url(@current_company.sub_domain)
              elsif is_staff?
                d_path = staff_tickets_url(@current_company.sub_domain)
              elsif is_user? 
                d_path = new_ticket_url(@current_company.sub_domain)
              else
                d_path = root_url  
              end
            else
              d_path = root_url  
            end  
          end
          
          format.html { redirect_to d_path }
          format.xml { render :xml => @user_session, :status => :created, :location => @user_session }
        else
          reset_session
          @user_session = UserSession.new(params[:user_session])
          flash[:error] = t("general.you_are_not_active_user")
          format.html { render :action => "new" }
        end
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET logout
  def destroy
    sub_domain = @current_company ? @current_company.sub_domain : ""
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end
    reset_session
    flash[:notice] = t("general.logout_successful")
    respond_to do |format|
      format.html { redirect_to (sub_domain.present? ? company_front_path(sub_domain) : root_url) }
      format.xml { head :ok }
    end
  end

  # GET signup
  def signup
    @o_single = User.new
    if request.post?
      params[:user][:password_confirmation] = params[:user][:password]
      params[:user][:registration_key] = SecureRandom.hex(25)
      params[:user][:time_zone] = 'UTC'
      @o_single = User.new(user_params)

      respond_to do |format|
        if @o_single.save
          @o_single.role = Role.find_by(:role_type => USER)
          opts = {
            :username => @o_single.email, 
            :email => @o_single.email, 
            :password => params[:user][:password], 
            :registration_key => @o_single.registration_key
          }
          UserMailer.registration_confirmation(@o_single.email, opts).deliver

          @user_session = UserSession.new
          @user_session.email = @o_single.email
          @user_session.password = params[:user][:password]

          if @user_session.save
            session[:user_id] = current_user.id
            session[:user_role] = current_user.role.role_type
            notice = t("general.successfully_registered")
          end
          format.html { redirect_to new_ticket_url(@current_company.sub_domain), notice: notice }
          format.json { render action: 'show', status: :created, location: @o_single }
        else
          format.html { render action: 'signup' }
          format.json { render json: @o_single.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_session_params
      params[:user_session]
    end

    def user_params
      params.require(:user).permit!
    end
end
