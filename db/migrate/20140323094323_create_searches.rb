class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.references :user, index: true

      t.string :name,          null: false
      t.boolean :active,       null: false, default: true
      t.timestamp :last_run_at
      t.timestamp :next_run_at

      t.text :schedule

      t.timestamps
    end
  end
end
