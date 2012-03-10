class ChangeManipulationTypeCollumn < ActiveRecord::Migration
  def up
    rename_column :manipulations, :type, :sort
  end

  def down
    rename_column :manipulations, :sort, :type
  end
end
