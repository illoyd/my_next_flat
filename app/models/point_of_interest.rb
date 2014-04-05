class PointOfInterest < ActiveRecord::Base
  has_many :locations, inverse_of: :point_of_interest
  
  scope :stations, ->{ where( kind: 'station' ) }
end
