class Admin::SessionsController < ApplicationController
  before_filter :sign_out, only:[:index]

  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to admin_dashboards_path
      flash[:success] = "You have logged in successfully!"
    else
      redirect_to root_path
      flash[:error] = "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
    flash[:notice] = "Logged Out successfully!"
  end
end