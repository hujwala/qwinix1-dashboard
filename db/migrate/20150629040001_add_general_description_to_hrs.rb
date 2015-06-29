class AddGeneralDescriptionToHrs < ActiveRecord::Migration
  def change
    add_column :hrs, :general_description, :string
  end
end
