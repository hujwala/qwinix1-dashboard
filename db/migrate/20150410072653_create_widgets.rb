class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :name
      t.string :widget_type

      t.timestamps
    end
  end
end
