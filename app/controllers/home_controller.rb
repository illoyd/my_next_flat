class HomeController < ApplicationController
  skip_authorization_check :index
  
  def index
    @recent_listings = MyNextFlat::CachedService.new.sample_cached_listings(4)
  end

end
