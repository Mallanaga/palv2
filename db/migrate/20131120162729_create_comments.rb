class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :event
      t.belongs_to :user
      t.text :comment
      t.timestamps
    end
    add_index :comments, :event_id
    add_index :comments, :user_id
  end
end
