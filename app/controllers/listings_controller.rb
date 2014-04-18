class ListingsController < ApplicationController

  skip_authorization_check :show

  def show
    @listing = Zoopla::CachedListings.new.find(params[:id])

    if @listing && @listing.latitude && @listing.longitude
      @nearby = PointOfInterest.near([@listing.latitude, @listing.longitude], 1.0, units: :mi)
    else
      @nearby = PointOfInterest.none
    end

    @map = { id: 'map', markers: [@listing], latitude: @listing.latitude, longitude: @listing.longitude }
  end

end
