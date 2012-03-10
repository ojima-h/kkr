class DeleteRestriction < ActiveRecord::Migration
  def up
    drop_table :restrictions
  end

  def down
  end
end
