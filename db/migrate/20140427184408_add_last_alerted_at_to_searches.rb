class AddLastAlertedAtToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :last_alerted_at, :timestamp
  end
end
