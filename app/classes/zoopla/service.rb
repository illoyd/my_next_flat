require 'zoopla/error'

module Zoopla

  class Service
    include APISmith::Client
    base_uri "http://api.zoopla.co.uk/"
    endpoint "api/v1/"
    #debug_output $stdout
      
    def initialize(key=nil)
      key ||= Rails.application.secrets.zoopla_api_key
      add_query_options!( api_key: key )
    end
    
    def listing(id)
      params = { listing_id: id }
      query(params).try(:first)
    end
    
    def search(search)
      results = build_queries(search).map { |query| query(query) }
      results.flatten.uniq
    end
    
    def query(query)
      params = query.merge( order_by: 'age', ordering: 'descending' )
      response = get "property_listings.json", extra_query: params #, response_container: %w( listing ), transform: Zoopla::Listing
      assert_valid!(response)
      Zoopla::Listing.call(response['listing'])
    end
    
    def raw(query)
      params = query.merge( order_by: 'age', ordering: 'descending' )
      get "property_listings.json", extra_query: params
    end
    
    def base_request_options
      { headers: { 'Accept' => 'application/json' } }
    end
    
    protected
    
    ##
    # The response cannot contain a 'dismabiguation' error.
    def assert_valid!(response)
      return if response['error_code'].blank?
      case response['error_code']
        when '-1'
          raise Zoopla::DisambiguationError.new(response['error_string'], response)
        when '7'
          raise Zoopla::UnknownLocationError.new(response['error_string'], response)
        else 
          raise Zoopla::Error.new(response['error_string'], response)
      end
    end
    
    def build_queries(search)
      query_combinations(search).map { |terms| build_query(terms) }
    end
    
    def query_combinations(search)
      search.locations.product(search.criterias)
    end
    
    def build_query(*terms)
      Array.wrap(*terms).inject({}) do |query, term|
        query.merge( build_params(term) )
      end
    end
    
    def build_params(term)
      params = case term
        when Location
          build_location_params(term)
        when Criteria
          build_criteria_params(term)
        else
          raise Zoopla::Error, "Could not build search parameters for #{ term.class.to_s }."
      end
      params.reject{ |k,v| v.nil? }
    end
    
    def build_location_params(location)
      specific_params = case location
        when StreetLocation
          build_street_location_params(location)
        when LatLonLocation
          build_lat_lon_location_params(location)
        else
          build_area_location_params(location)
      end

      general_params = {
        radius: location.radius
      }

      general_params.merge(specific_params)
    end
    
    def build_area_location_params(location)
      {
        area:    location.area,
        country: location.country
      }
    end
    
    def build_street_location_params(location)
      {
        street:  location.street,
        town:    location.town,
        country: location.country
      }
    end
    
    def build_lat_lon_location_params(location)
      {
        latitude:  location.latitude,
        longitude: location.longitude
      }
    end
    
    def build_criteria_params(criteria)
      {
        listing_status: ( criteria.class == BuyCriteria ? 'sale' : 'rent' ),

        minimum_price:  criteria.min_price,
        maximum_price:  criteria.max_price,
                        
        minimum_beds:   criteria.min_beds,
        maximum_beds:   criteria.max_beds,
                        
        minimum_baths:  criteria.min_baths,
        maximum_baths:  criteria.max_baths
      }
    end
    
    def listing_status_for(criteria)
      case criteria
        when BuyCriteria
          'sale'
        when LetCriteria
          'rent'
        else
          raise Error, "Unknown listing_status for #{ criteria.class.to_s }."
        end
    end
    
  end


end
