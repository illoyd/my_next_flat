class AddMessageToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :message, :text
  end
end
