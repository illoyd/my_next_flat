module Zoopla

  class LocationParams < APISmith::Smash
    property :street
    property :town
    property :country
    property :radius
  end

end
