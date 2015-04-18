class Admin::UsersController < ApplicationController

	def index
		@user = User.new
  end

	def new
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to admin_dashboards_path
    else
      redirect_to root_path
		end
	end

	def show
		@users = User.all
	end

	def create
		@user = User.new(user_params)
		if @user.valid?
      @user.add_role :admin
      @user.save
			@success = true
			flash[:success] = "You have logged in successfullly!"
		else
			@success = false
		end
	end

   def add_new_user
    @user = User.new
   end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end












