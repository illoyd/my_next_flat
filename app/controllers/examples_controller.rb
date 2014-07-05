class ExamplesController < ApplicationController
  skip_authorization_check :index

  # GET /examples
  # GET /examples.json
  def index
    @local_area = request.location.try(:city)
    @local_area = 'London' if @local_area.blank?

    @local_search = local_search(@local_area)
    @local_listings = Zoopla::CachedListings.new.search(@local_search) rescue []
    
    @local_map_center = Geocoder::Calculations.geographic_center(@local_listings.map { |ll| [ll.latitude, ll.longitude] })

    @map = { id: 'map', markers: @local_listings, latitude: @local_map_center[0], longitude: @local_map_center[1] }
    
    @searches = Example.examples
  end

  # GET /examples/1
  # GET /examples/1.json
  def show
    # Request the example and clone it for the current user
    search = Example.examples.find(params[:id]).dup_as_search_for(current_or_guest_user)
    
    # Redirect to the new search
    redirect_to search
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
