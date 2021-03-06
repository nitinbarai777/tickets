class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :is_admin?, :is_user?, :is_staff?, :is_company_admin?
  before_filter :current_company
	SUPER_ADMIN = "SuperAdmin"
	COMPANY_ADMIN = "CompanyAdmin"
	USER = "User"
  STAFF = "Staff"
  
  private

    def current_company
      return @current_company if defined?(@current_company)
      if session[:current_sub_domain]
        @current_company = Company.find_by(:sub_domain => session[:current_sub_domain])
        session[:current_company_id] = @current_company.id
      else
        @current_company = Company.find_by(:url => request.host)
      end
    end 

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
	    @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        redirect_to root_url
      end
    end
    
    def require_admin
      unless session[:user_role] == SUPER_ADMIN
        redirect_to root_url
      end
    end

    def require_company_admin
      unless session[:user_role] == COMPANY_ADMIN
        redirect_to root_url
      end
    end  
    
    def require_admin_or_company_admin
      unless session[:user_role] == COMPANY_ADMIN || session[:user_role] == SUPER_ADMIN
        redirect_to root_url
      end
    end  
    
    def require_company
      unless current_company
        redirect_to root_url
      end      
    end
    
    def require_staff
      unless session[:user_role] == STAFF
        redirect_to root_url
      end
    end    

    def authenticate_email(email)
      user = User.where(:email => email).first
      if user
			  return user
	    end
	    return false
    end

    def authenticate_change_password(password)
        user_exists = User.exists?(password: password)
        if user_exists
		  user = User.find_by_password(password)
		  return user
	    end
	    return false
    end

	  def is_admin?
		  session[:user_role] == SUPER_ADMIN
	  end

    def is_user?
	   session[:user_role] == USER
    end
    
    def is_staff?
     session[:user_role] == STAFF
    end
    
    def is_company_admin?
     session[:user_role] == COMPANY_ADMIN
    end        

    def ticket_status_hash
      {"1" => "Open", "2" => "On Hold", "3" => "Close"}
    end
    
    def ticket_priority_hash
      {"1" => "Low", "2" => "Medium", "3" => "High", "4" => "Urgent", "5" => "Emergency", "6" => "Critical"}
    end

end
