class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ApplicationHelper
  protect_from_forgery with: :exception
  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def require_login
    if session[:user_id] == nil || current_user.nil?
      session[:user_id] = nil
      redirect_to root_path
    end
  end
  def sign_out
    if session[:user_id] 
      redirect_to admin_dashboards_path
    end
  end
end
