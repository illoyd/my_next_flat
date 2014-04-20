class AddTwitterToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_uid,       :string
    add_column :users, :twitter_handle,    :string
    add_column :users, :profile_image_url, :string
  end
end
