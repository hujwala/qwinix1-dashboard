class AddProjectNameToDashboardWidgets < ActiveRecord::Migration
  def change
    add_column :dashboard_widgets, :jira_project_key, :string
  end
end
