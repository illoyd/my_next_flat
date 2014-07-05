class ExamplesController < ApplicationController
  skip_authorization_check :index

  # GET /examples
  # GET /examples.json
  def index
    @examples = Example.examples
  end

  # GET /examples/1
  # GET /examples/1.json
  def show
    # Request the example and clone it for the current user
    search = Example.examples.find(params[:id]).dup_as_search_for(current_or_guest_user)
    
    # Redirect to the new search
    redirect_to search
  end

end
