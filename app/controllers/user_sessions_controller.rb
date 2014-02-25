class UserSessionsController < ApplicationController

  # GET /user_sessions
  def index
    redirect_to new_user_session_path
  end

  # GET login
  def new
    if current_user
      redirect_to root_path
    else   
      @user_session = UserSession.new
      respond_to do |format|
        format.html # new.html.erb
        format.xml { render :xml => @user_session }
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
          format.html { redirect_to(is_admin? ? admin_users_url : new_ticket_url, :notice => notice) }
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
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end
    reset_session
    flash[:notice] = t("general.logout_successful")
    respond_to do |format|
      format.html { redirect_to "/" }
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
          format.html { redirect_to new_ticket_url, notice: notice }
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
