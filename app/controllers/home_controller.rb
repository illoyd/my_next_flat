class HomeController < ApplicationController
  skip_authorization_check :index
  
  def index
    @local_search = local_search(area)
    @local_listings = Zoopla::CachedListings.new.search(@local_search)
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
