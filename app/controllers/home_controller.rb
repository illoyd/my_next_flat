class HomeController < ApplicationController
  skip_authorization_check :index
  
  def index
  end

end
