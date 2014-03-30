class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :search, index: true
      t.string :type

      t.string :area,       null: false
      t.string :country
      t.float :radius,      null: false, default: 0

      t.timestamps
    end
  end
end
