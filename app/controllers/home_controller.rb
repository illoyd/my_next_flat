class HomeController < ApplicationController
  skip_authorization_check :index
  
  def index
    @local_area = request.location.try(:city)
    @local_area = 'London' if @local_area.blank?

    @local_search = local_search(@local_area)
    @local_listings = Zoopla::CachedListings.new.search(@local_search) rescue []
    
    @local_map_center = Geocoder::Calculations.geographic_center(@local_listings.map { |ll| [ll.latitude, ll.longitude] })

    @map = { id: 'map', markers: @local_listings, latitude: @local_map_center[0], longitude: @local_map_center[1] }
  end

  protected

  def local_search(area)
    search = Search.new.tap do |ss|
      ss.locations << Location.new(area: area, radius: 2.0)
      ss.criterias << BuyCriteria.new
      ss.criterias << LetCriteria.new
    end
  end

end
