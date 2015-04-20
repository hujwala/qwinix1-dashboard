class Admin::UsersController < ApplicationController

	def index
		@users = User.all
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












