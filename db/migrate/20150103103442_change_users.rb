class ChangeUsers < ActiveRecord::Migration

  def up
    remove_index :users, :reset_password_token

    change_table(:users) do |t|

      # Drop password and reset columns
      t.remove :encrypted_password
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      
      # Drop the twitter columns (these are moving to the identities objects)
      t.remove :twitter_uid
      t.remove :twitter_handle
      t.remove :real_email

      # Add columns
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      
      # Rename the photo URL
      t.rename :profile_image_url, :photo_url
      
      # Add a new big photo URL
      t.string :big_photo_url

    end

    add_index :users, :confirmation_token,   :unique => true
  end

  def down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end

end
