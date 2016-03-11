class SessionsController < ApplicationController
	skip_before_filter :check_session

	include SessionsHelper
	def new
		
	end

	def create
		@user = User.authentication(params[:login], params[:password])
		if @user
			# session[:user_id] = @user.id
			log_in(@user)
			# flash[:notice] = "欢迎 #{@user.login}"
			redirect_to root_path
		else
			flash[:alert] = "用户名或者密码错误,请重试!"
			redirect_to login_path
		end
	end

	def destory
		log_out if logged_in #SessionsHelper中的方法
    redirect_to login_path
	end
end
