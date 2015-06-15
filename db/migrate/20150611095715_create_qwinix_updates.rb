class CreateQwinixUpdates < ActiveRecord::Migration
  def change
    create_table :qwinix_updates do |t|
      t.string :widget_name
      t.text :description

      t.timestamps
    end
  end
end
