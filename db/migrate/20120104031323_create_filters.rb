class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :cond

      t.timestamps
    end
  end
end
