class ChangeLocationDefaults < ActiveRecord::Migration
  def change
    change_column :users, :location, :string, default: 'Central Time (US & Canada)'
  end
end
