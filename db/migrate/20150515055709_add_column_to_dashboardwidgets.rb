class AddColumnToDashboardwidgets < ActiveRecord::Migration
  def change
  	add_column :dashboard_widgets, :jenkins_name, :string
  	add_column :dashboard_widgets, :jenkins_password, :string
  	add_column :dashboard_widgets, :jenkins_url, :string
  end
end
