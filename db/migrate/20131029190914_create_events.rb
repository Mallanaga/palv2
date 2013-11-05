class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.text :why
      t.string :location
      t.float :lat
      t.float :lng
      t.boolean :private, default: false
      t.timestamps
    end
    add_index :events, :name
    add_index :events, :date
    add_index :events, [:lat, :lng]
  end
end
