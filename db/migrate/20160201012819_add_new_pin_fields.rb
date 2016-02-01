class AddNewPinFields < ActiveRecord::Migration
  def change
        add_column :pins, :title, :string, null: false
        add_column :pins, :note, :text
  end
end
