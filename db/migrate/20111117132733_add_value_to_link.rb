class AddValueToLink < ActiveRecord::Migration
  def self.up
    add_column :links, :value, :string
    add_column :links, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :links, :hidden
    remove_column :links, :value
  end
end
