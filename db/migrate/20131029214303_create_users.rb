class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :gender, default: :F
      t.date :dob
      t.boolean :admin, default: false
      t.string :location
      t.float :lat
      t.float :lng
      t.string :password_digest
      t.string :remember_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps
    end
    add_index :users, :email, unique: :true
    add_index :users, :remember_token
    add_index :users, [:lat, :lng]
  end
end
    