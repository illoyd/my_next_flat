class ListingsController < ApplicationController

  skip_authorization_check :show

  def show
    @listing = MyNextFlat::CachedService.new.listing(params[:id])
  end

end
