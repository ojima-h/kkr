class AddColorToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :color, :string, :limit => 16
  end

  def self.down
    remove_column :tags, :color
  end
end
