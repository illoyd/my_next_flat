class AddLatitudeAndLongitudeToLocation < ActiveRecord::Migration
  def change
    change_table(:locations) do |t|
      t.float :latitude
      t.float :longitude
    end
  end
end
