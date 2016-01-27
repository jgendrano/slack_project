class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :channel_id
      t.string :channel_name
      t.string :purpose
      t.timestamps null: false
    end
  end
end
