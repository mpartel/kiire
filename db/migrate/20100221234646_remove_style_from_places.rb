class RemoveStyleFromPlaces < ActiveRecord::Migration
  def self.up
    remove_column :places, :serialized_style
  end

  def self.down
    add_column :places, :serialized_style, :string, :null => false, :default => ''
    change_column_default :places, :serialized_style, nil
  end
end
