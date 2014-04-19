class AddTopNToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :top_n, :int, default: 1
  end
end
