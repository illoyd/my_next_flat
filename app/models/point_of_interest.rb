class PointOfInterest < ActiveRecord::Base
  has_many :locations, inverse_of: :point_of_interest
  reverse_geocoded_by :latitude, :longitude

  scope :stations, ->{ where( kind: 'station' ) }

  scope :points_of_interest, ->{ where(kind: 'poi') }
  scope :tfl_stations,       ->{ where(kind: 'tfl_station') }

end
