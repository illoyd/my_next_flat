class Coordinates

  REGEX = /\A(?<lat>-?[0-9\.]+), *(?<lon>-?[0-9\.]+)\z/

  attr_reader :latitude, :longitude

  def initialize(sz)
    sz =~ REGEX
    @latitude  = $1.to_f
    @longitude = $2.to_f
  end
  
  def to_s
    "#{ self.latitude }, #{ self.longitude }"
  end

end
