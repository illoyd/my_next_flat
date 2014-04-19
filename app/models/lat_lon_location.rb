class LatLonLocation < Location

  def coordinates
    @coordinates ||= Coordinates.new(self.area)
  end
  
  def coordinates=(value)
    self.area = value.to_s
  end
  
  def geocode_async
    self.latitude = self.coordinates.latitude
    self.longitude = self.coordinates.longitude
    true
  end

end
