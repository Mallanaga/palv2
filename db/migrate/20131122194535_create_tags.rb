class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.belongs_to :event
      t.belongs_to :category
      t.timestamps
    end
    add_index :tags, :category_id
  end
end
