module Zoopla

  class ListingsQuery < BasicObject
    def initialize(api = nil)
      @api    = api || ::Zoopla::Listings.new
      @params = ::Hashie::Clash.new
    end
  
    def api
      @api
    end
    
    def api=(value)
      @api = value
    end
    
    def params
      @params
    end
    
    delegate :to_hash, to: :params

    def where(*components)
      components.each { |component| @params.merge!(self.params_for(component)) }
      self
    end
    
    def first
      self.execute.first
    end
    
    def execute
      @api.query(@params)
    end
    
    alias_method :all, :execute
    alias_method :to_a, :execute

    delegate :each, to: :execute

    alias_method :query_for, :where
    
    def params_for(term)
      data = term.as_json
      parsed = case term
        when ::StreetLocation then ::Zoopla::StreetLocationParams.call(data)
        when ::LatLonLocation then ::Zoopla::LatLonLocationParams.call(data)
        when ::Location       then ::Zoopla::LocationParams.call(data)
        when ::BuyCriteria    then ::Zoopla::BuyCriteriaParams.call(data)
        when ::LetCriteria    then ::Zoopla::LetCriteriaParams.call(data)
        when ::Criteria       then ::Zoopla::CriteriaParams.call(data)
        when ::Hash           then data
        else
          raise ::Zoopla::Error.new("Could not build search parameters for #{ term.class.to_s }.")
      end
      parsed.to_hash.reject{ |k,v| v.nil? }
    end
    
    def method_missing(method, *args, &block)
      value =  @params.send(method, *args, &block)
      value == @params ? self : value
    end

  end
end
