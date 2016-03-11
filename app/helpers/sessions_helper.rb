module SessionsHelper
	#一旦账号密码正确，则成功登录，同时在session中记录session[:user_id]
  def log_in(user)
    session[:user_id] = user.id
    session[:user_login] = user.login
  end

  #用来判断用户是否登录的方法
  def logged_in
    if session[:user_id]
    	return true
    else
    	return false
    end
  end

  #退出，同时删除session中的信息
  def log_out
    session.delete(:user_id)
    session.delete(:user_login)
  end
end
