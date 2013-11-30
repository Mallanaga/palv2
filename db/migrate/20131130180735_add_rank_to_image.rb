class AddRankToImage < ActiveRecord::Migration
  def change
    add_column :images, :rank, :decimal
  end
end
