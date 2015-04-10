class AddReferencesToDashboardWidgets < ActiveRecord::Migration
	def change
		add_reference :dashboard_widgets, :dashboard, index: true
		add_reference :dashboard_widgets, :widget, index: true
	end

end
