module MyNextFlat

  class CachedService
    attr_accessor :service

    def initialize(service = nil)
      self.service = service || Zoopla::Service.new
    end
    
    ##
    # Get a specific listing by ID.
    def listing(listing_id)
      return ListingCache.listing(listing_id) if ListingCache.cached?(listing_id)

      # Request and cache
      listing = self.service.listing(listing_id)
      ListingCache.cache_nil(listing_id) if listing.nil?
      ListingCache.cache(listing)
      listing
    end
    
    ##
    # Perform searches, using cache first if available. If a new search is required, then cache the results as well.
    def search(search_or_id)
      search_id = search_or_id.try(:id) || search_or_id
      search    = search_or_id.is_a?(Search) ? search_or_id : Search.find(search_id)
      return SearchResultCache.results(search_id) if SearchResultCache.cached?(search_id)

      # Request and cache
      results = self.service.search(search)
      SearchResultCache.cache_nil(search) if results.nil?
      SearchResultCache.cache(search, results)
      results
    end
    
    def clear(search_or_id)
      SearchResultCache.clear(search_or_id)
    end
    
    def cached_search?(search)
      SearchResultCache.cached?(search)
    end
    
    def sample_cached_listings(count)
      keys = ListingCache.keys.sample(count)
      $redis.mget(keys).map{ |value| ListingCache.deserialize(value) }
    end
    
    ##
    # Get the search from the cache if available
    def cached_search(search)
      key = search_cache_key(search)
      get_object(search)
    end

    ## Set the cache
    def cached_search=(search)
      key = search_cache_key(search)
      set_json(key, object, default_search_ttl)
    end
    
    def default_search_ttl
      8.hours.seconds
    end
    
    def default_listing_ttl
      8.hours.seconds
    end
    
    def get_json(key)
      JSON.parse($redis.get(key))
    end
    
    def get_object(key, klass)
      klass.new(key)
    end

    def set_json(key, object, ttl=nil)
      if ttl
        $redis.setex(key, ttl, object.to_json)
      else
        $redis.set(key, object.to_json)
      end
    end

    protected
    
    def search_cache_key(search)
      "search:#{ search.id }"
    end
    
    def listing_cache_key(listing)
      "listing:#{ listing.id }"
    end
    
  end

end
