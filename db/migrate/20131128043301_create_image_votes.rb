class CreateImageVotes < ActiveRecord::Migration
  def change
    create_table :image_votes do |t|
      t.belongs_to :user
      t.belongs_to :image
      t.integer :value

      t.timestamps
    end
    add_index :image_votes, :image_id
    add_index :image_votes, :user_id
  end
end
