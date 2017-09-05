module UsersHelper
	
  def log_in(user)
    session[:user_id] = user.id
  end

  # 获取当前登录用户
  def current_user
    # 判断session是否有用户ID
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
    end
  end

    # 用来判断用户是否登录
    def logged_in?
      !current_user.nil?
    end

    # 退出登录
    def log_out
      session.delete(:user_id)
      @current_user = nil
    end

    # before_action, 用于检测用户是否登录，未登录的话则跳转到登录界面
    def require_login
      if !logged_in?
        redirect_to login_path
        return
      end
    end
end
