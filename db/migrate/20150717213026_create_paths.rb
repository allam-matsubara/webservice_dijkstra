class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string  :point_a
      t.string  :point_b
      t.string  :name
      t.integer :distance

      t.timestamps null: false
    end
  end
end
