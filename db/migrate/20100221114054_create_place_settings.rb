class CreatePlaceSettings < ActiveRecord::Migration
  def self.up
    create_table :place_settings do |t|
      t.integer :place_id, :null => false
      t.text :backend, :null => true
      t.text :key, :null => false
      t.text :value, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :place_settings
  end
end
