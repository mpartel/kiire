class CorrectKeyOnPlaceSettings < ActiveRecord::Migration
  def self.up
    remove_index :place_settings, [:key, :backend]
    add_index(:place_settings, [:place_id, :key, :backend], :unique => true)
  end

  def self.down
    remove_index :place_settings, [:place_id, :key, :backend]
    add_index(:place_settings, [:key, :backend], :unique => true)
  end
end
