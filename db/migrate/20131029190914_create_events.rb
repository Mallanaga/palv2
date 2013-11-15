class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :user
      t.string :name
      t.datetime :start
      t.datetime :finish
      t.text :description
      t.string :location
      t.float :lat
      t.float :lng
      t.boolean :private, default: false
      t.integer :est_att
      t.timestamps
    end
    add_index :events, :name
    add_index :events, :start
    add_index :events, [:lat, :lng]
  end
end
