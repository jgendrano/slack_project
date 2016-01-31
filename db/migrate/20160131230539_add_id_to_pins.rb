class AddIdToPins < ActiveRecord::Migration
  def up
    remove_column :pins, :id
    add_column :pins, :id, :primary_key
  end

  def down
    remove_column :pins, :id
    add_column :pins, :id, :integer
  end

end
