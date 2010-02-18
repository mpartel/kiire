class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.user_id :integer, :null => false
      t.text :name, :null => false
      t.text :serialized_style, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
