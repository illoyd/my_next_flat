class ListingsController < ApplicationController

  skip_authorization_check :show

  def show
    @listing = Zoopla::CachedListings.new.find(params[:id])
    @map = { id: 'map', markers: [@listing], latitude: @listing.latitude, longitude: @listing.longitude }
  end

end
