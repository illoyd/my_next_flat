class AddPointOfInterestToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :point_of_interest, index: true
    add_foreign_key :locations, :point_of_interests
  end
end
