class SearchesController < ApplicationController

  load_and_authorize_resource

  # GET /searches
  # GET /searches.json
  def index
    redirect_to :home
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    begin
      @listings = Zoopla::CachedListings.new.search(@search).sort_by(&:updated_at).reverse!
      @search.message = nil
    rescue Zoopla::Error => ex
      @listings = []
      @search.message = ex.message
      logger.error ex.message
    ensure
      @search.save
    end

    @results = @listings
    @map = { id: 'map', markers: @listings, latitude: @listings.first.try(:latitude) || 51.5072, longitude: @listings.first.try(:longitude) || 0.1275 }
  end

  # GET /searches/new
  def new
    @search.locations.build if @search.locations.empty?
    @search.criterias.build if @search.criterias.empty?
  end

  # GET /searches/1/edit
  def edit
    @search.locations.build if @search.locations.empty?
    @search.criterias.build if @search.criterias.empty?
  end

  # POST /searches
  # POST /searches.json
  def create
    @search.user = current_or_guest_user

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: 'Search was successfully created.' }
        format.json { render action: 'show', status: :created, location: @search }
      else
        format.html { render action: 'new' }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @search }
      else
        format.html { render action: 'edit' }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:name, :alert_method, :day_of_week, :hour_of_day, :top_n, { locations_attributes: [ :id, :type, :area, :radius, :_destroy ], criterias_attributes: [ :id, :type, :min_price, :max_price, :min_beds, :max_beds, :min_baths, :max_baths, :_destroy ] })
    end
end
