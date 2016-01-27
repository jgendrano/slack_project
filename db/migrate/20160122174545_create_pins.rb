class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.belongs_to :user, null: false
      t.string :slack_username
      t.datetime :ts
      t.text :slack_message
      t.timestamps
    end
  end
end
