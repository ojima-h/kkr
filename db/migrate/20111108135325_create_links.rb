class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.references :note
      t.references :tag

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
