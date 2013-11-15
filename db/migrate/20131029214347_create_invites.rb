class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.belongs_to :user
      t.belongs_to :event
      
      t.timestamps
    end
    add_index :invites, [:user_id, :event_id], unique: :true
  end
end
