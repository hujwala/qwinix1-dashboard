class AddEventDescriptionToHrs < ActiveRecord::Migration
  def change
    add_column :hrs, :event_description, :string
  end
end
