class LatLonLocation < Location

  def coordinates
    @coordinates ||= Coordinates.new(self.area)
  end
  
  def coordinates=(value)
    self.area = value.to_s
  end
  
  def area=(value)
    super
    @coordiantes = nil
  end
  
  delegate :latitude, :longitude, to: :coordinates

end
