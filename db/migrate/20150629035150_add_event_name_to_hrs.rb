class AddEventNameToHrs < ActiveRecord::Migration
  def change
    add_column :hrs, :event_name, :string
  end
end
