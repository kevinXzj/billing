class ApplicationController < ActionController::Base
	include SessionsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_session

  private
  def check_session
  	if !logged_in #SessionsHelper中的方法
  		redirect_to login_path
  	end
  end
end
