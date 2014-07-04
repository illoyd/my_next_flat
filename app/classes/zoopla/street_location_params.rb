module Zoopla

  class StreetLocationParams < APISmith::Smash
    property :street
    property :town
    property :country
    property :radius
  end

end
