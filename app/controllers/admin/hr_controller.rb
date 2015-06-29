class Admin::HrController < ApplicationController
	def index
    	@hrs = Hr.last
	end
	def create
		@hrs = Hr.new(hr_params)
    if @hrs.valid?
    @hrs.save
      @success = true
    else
     @success = false
   end
      redirect_to admin_hr_index_path
	end
  def update
  end
	def hr_params
    params.require(:hrs).permit(:name1, :description1, :birthday, :employee_name ,:acheveiments,:event_name,:event_description,:general_description,:general_name)
  end
end