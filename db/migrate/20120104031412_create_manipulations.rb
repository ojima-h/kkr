class CreateManipulations < ActiveRecord::Migration
  def change
    create_table :manipulations do |t|
      t.references :filter
      t.string     :type
      t.string     :object
      t.string     :value

      t.timestamps
    end
    add_index :manipulations, :filter_id
  end
end
