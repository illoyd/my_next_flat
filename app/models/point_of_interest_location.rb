class PointOfInterestLocation < LatLonLocation
  belongs_to :point_of_interest, inverse_of: :locations
  
  validates_presence_of :point_of_interest
  
  before_validation :geocode_async
  
  def geocode_async
    # Simply pull the name and coordinates from the POI
    if self.point_of_interest.present?
      self.area = self.point_of_interest.name
      self.latitude = self.point_of_interest.latitude
      self.longitude = self.point_of_interest.longitude
    end
    true
  end

end
