class AddEmployeeNameToHrs < ActiveRecord::Migration
  def change
    add_column :hrs, :employee_name, :string
  end
end
