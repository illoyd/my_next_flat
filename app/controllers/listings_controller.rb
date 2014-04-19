class ListingsController < ApplicationController
  before_action :load_listing, only: :show
  before_action :load_and_authorize_search
  skip_authorization_check :show  

  def show
    load_nearbys
    load_map
  end
  
  protected
  
  def load_listing
    @listing = Zoopla::CachedListings.new.find(params[:id])
  end
  
  def load_and_authorize_search
    if params[:search_id]
      @search = current_or_guest_user.searches.find_by(id: params[:search_id])
      redirect_to listing_path(@listing.id) if @search.blank?
    end
  end
  
  def load_nearbys
    if @listing && @listing.latitude && @listing.longitude
      @nearby = PointOfInterest.near([@listing.latitude, @listing.longitude], 1.0, units: :mi)
    else
      @nearby = PointOfInterest.none
    end
  end
  
  def load_map
    @map = { id: 'map', markers: [@listing], latitude: @listing.try(:latitude), longitude: @listing.try(:longitude) }
  end
  
end
