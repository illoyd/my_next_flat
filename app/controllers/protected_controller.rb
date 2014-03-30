class ProtectedController < ApplicationController

  ##
  # Require authentication
  before_filter :authenticate_user!

end
