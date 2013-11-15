class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.belongs_to :event
      t.belongs_to :user
      t.string :iCalUID
      t.boolean :cancel, default: false
      t.timestamps
    end
    add_index :attendances, [:event_id, :user_id], unique: :true
  end
end
