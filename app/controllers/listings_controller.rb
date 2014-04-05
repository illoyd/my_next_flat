class ListingsController < ApplicationController

  skip_authorization_check :show

  def show
    @listing = Zoopla::CachedListings.new.find(params[:id])
  end

end
