class AddAcheveimentsToHrs < ActiveRecord::Migration
  def change
    add_column :hrs, :acheveiments, :string
  end
end
