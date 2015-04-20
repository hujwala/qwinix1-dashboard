class Admin::UsersController < ApplicationController
  before_filter :require_login

	def index
		@users = User.all
  end

  def unique_email
    @user = User.find_by_email(params[:user][:email])
    respond_to do |format|
      format.json { render :json => !@user }
    end
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.add_role :admin
      @user.save
      @success = true
    else
     @success = false
   end
 end

 private

 def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end
end












