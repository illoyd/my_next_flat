class PointOfInterest < ActiveRecord::Base
  has_many :locations, inverse_of: :point_of_interest
  reverse_geocoded_by :latitude, :longitude

  scope :stations, ->{ where( kind: 'station' ) }
end
