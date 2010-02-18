class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :user_id, :null => false
      t.text :key, :null => false
      t.text :value, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
