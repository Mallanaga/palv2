class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.belongs_to :event
      t.belongs_to :user
      t.text :description
      t.string :image_url
      t.timestamps
    end
    add_index :images, :event_id
    add_index :images, :user_id
  end
end
