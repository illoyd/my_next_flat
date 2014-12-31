class AdsController < ApplicationController
  layout false
  skip_authorization_check :show
  
  def show
  end
end
