class CreateHrs < ActiveRecord::Migration
  def change
    create_table :hrs do |t|
      t.string :name1
      t.string :description1

      t.timestamps
    end
  end
end
