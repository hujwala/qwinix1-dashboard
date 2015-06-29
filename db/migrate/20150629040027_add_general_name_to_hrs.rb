class AddGeneralNameToHrs < ActiveRecord::Migration
  def change
    add_column :hrs, :general_name, :string
  end
end
