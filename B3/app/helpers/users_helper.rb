module UsersHelper
	def log_in(user)
		session[:admin_id] = user.id
    end

    def current_user
    	if(user_id = session[:admin_id])
    		@current_user ||= Admin.find(user_id)
    	end
    end

    def logged_in?
    	!current_user.nil?
    end

    def require_login
    	if !logged_in?
    		redirect_to login_path
    		return
    	end
    end

    def log_out
      session.delete(:user_id)
      @current_user = nil
      #redirect_to root_path
    end
end


