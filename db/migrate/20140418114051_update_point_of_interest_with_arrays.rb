class UpdatePointOfInterestWithArrays < ActiveRecord::Migration
  def change
    remove_column :point_of_interests, :zone
  
    add_column :point_of_interests, :zones, :string, array: true, default: '{}'
    add_column :point_of_interests, :lines, :string, array: true, default: '{}'
    
    add_index  :point_of_interests, :zones, using: 'gin'
    add_index  :point_of_interests, :lines, using: 'gin'
  end
end
