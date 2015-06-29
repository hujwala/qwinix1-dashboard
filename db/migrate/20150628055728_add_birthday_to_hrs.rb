class AddBirthdayToHrs < ActiveRecord::Migration
  def change
    add_column :hrs, :birthday, :string
  end
end
