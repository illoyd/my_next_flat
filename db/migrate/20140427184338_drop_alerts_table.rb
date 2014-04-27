class DropAlertsTable < ActiveRecord::Migration
  def up
    drop_table :alerts
  end
  
  def down
    create_table :alerts do |t|
      t.integer  "search_id"
      t.string   "contact",        null: false
      t.datetime "last_performed", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "alerts", ["search_id"]
  end
end
