class AddStartEndToEvents < ActiveRecord::Migration
  def change
    rename_column :events, :date, :start
    add_column :events, :end, :datetime
  end
end
