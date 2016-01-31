class ChangePinTsColumn < ActiveRecord::Migration
 def up
    remove_column :pins, :ts
    add_column :pins, :ts, :datetime
  end

  def down
    remove_column :pins, :ts
    add_column :pins, :ts, :string
  end
end
