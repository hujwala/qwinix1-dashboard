class CreateDashboardWidgets < ActiveRecord::Migration
  def change
    create_table :dashboard_widgets do |t|
      t.string :access_token
      t.string :organization_name
      t.string :repo_name
      t.string :status
      t.string :github_url
      t.string :jira_url
      t.string :jira_view_id
      t.string :jira_name
      t.string :jira_password
      t.string :code_repo_id
      t.string :code_api_token

      t.timestamps
    end
  end
end
