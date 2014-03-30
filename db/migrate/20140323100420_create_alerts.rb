class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.references :search, index: true

      t.string :contact,           null: false
      t.timestamp :last_performed, null: false

      t.timestamps
    end
  end
end
