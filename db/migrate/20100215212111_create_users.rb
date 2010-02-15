class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.text :username, :null => false
      t.text :password_hash, :null => true
      t.text :email, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
