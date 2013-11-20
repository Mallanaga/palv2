class AddRangeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :range, :integer, default: 10
  end
end
