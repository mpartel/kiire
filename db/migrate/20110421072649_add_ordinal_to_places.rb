class AddOrdinalToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :ordinal, :int, :null => false, :default => 0
    execute "UPDATE `places` SET ordinal = id"
    add_index :places, [:user_id, :ordinal], :unique => true
  end

  def self.down
    remove_index :places, [:user_id, :ordinal]
    remove_column :places, :ordinal
  end
end
