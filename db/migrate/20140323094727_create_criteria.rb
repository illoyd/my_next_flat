class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria do |t|
      t.references :search, index: true
      t.string     :type, null: false
      
      t.boolean    :include_let,  null: false, default: false
      t.boolean    :include_sold, null: false, default: false
      
      t.boolean    :furnished

      t.integer    :min_price
      t.integer    :max_price
                   
      t.integer    :min_beds
      t.integer    :max_beds
                   
      t.integer    :min_baths
      t.integer    :max_baths

      t.timestamps
    end
  end
end
