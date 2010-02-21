class AddKeysToPlaceSettings < ActiveRecord::Migration
  def self.up
    add_index(:place_settings, [:key, :backend], :unique => true)
  end

  def self.down
    remove_index :place_settings, [:key, :backend]
  end
end
