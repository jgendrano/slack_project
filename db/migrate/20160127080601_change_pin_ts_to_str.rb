class ChangePinTsToStr < ActiveRecord::Migration
  def change
    change_column :pins, :ts, :string
  end
end
