class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :sharee_id
      t.integer :sharer_id
      t.timestamps
    end
    add_index :relationships, [:sharee_id, :sharer_id], unique: :true
  end
end
