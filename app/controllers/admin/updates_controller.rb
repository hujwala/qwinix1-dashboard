class Admin::UpdatesController < ApplicationController
	def index
    	@qwinix_update = QwinixUpdates.last
	end
  
	def create
		@qwinix_update = QwinixUpdates.new(update_params)
    if @qwinix_update.valid?
      @qwinix_update.save
      @success = true
      flash[:success] = "updates created successfully!"
    else
     @success = false
   end
      redirect_to admin_updates_path
	end
  def update
  end
	def update_params
    params[:updates].permit(:widget_name, :description)
  end
end