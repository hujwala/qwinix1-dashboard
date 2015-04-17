class AddColumnToDashboardWidgets < ActiveRecord::Migration
  def change
    add_column :dashboard_widgets, :github_status_prs, :string
  end
end
