class CreatePointOfInterests < ActiveRecord::Migration
  def change
    create_table :point_of_interests do |t|
      t.string :name
      t.string :kind

      t.float :latitude
      t.float :longitude

      t.string :zone

      t.timestamps
    end
  end
end
