class Admin::SessionsController < ApplicationController
  before_filter :sign_out, only:[:index]

  def index
    @user = User.new
  end

  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to admin_dashboards_path
    else
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end