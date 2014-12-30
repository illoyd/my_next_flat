module Zoopla

  class CachedListings < Listings
  
    TTL = 24.hours.seconds

    def search(search, extras={}, options={})
      queries(search, extras).reduce(Set.new) { |memo,query| memo.merge(self.query(query, options)) }
    end
    
    def query(query, options = {})
      options.reverse_merge!(default_options)
      
      # Get cache if available 
      if options[:use_cache]
        cached_results = get_cache(query)
        return cached_results if cached_results
      end
      
      # Query via parent
      results = options[:allow_query] ? super(query) : []
      
      # Add to cache
      if options[:use_cache] && options[:update_cache]
        set_cache(query, results) unless results.try(:empty?)
      end
      
      # Return results
      results
    end
    
    def default_options
      { use_cache: true, update_cache: true, allow_query: true }
    end
    
    def cache_key_for(query)
      query_terms = query.with_indifferent_access.reject { |k,v| v.nil? }
      'zoopla:listings:' + query_terms.keys.sort.map { |k| "#{ k }=#{ query_terms[k].to_s.downcase.gsub(/\s/,'') }" }.join(':')
    end

    def get_cache(query)
      cache_key = cache_key_for(query)
      Redis.current.exists(cache_key) ? Zoopla::Listing.call(JSON.parse(Redis.current.get(cache_key))) : nil
    end
    
    def set_cache(query, results)
      # Store the main search
      cache_key = cache_key_for(query)
      Redis.current.setex(cache_key, TTL, results.to_json)
      
      # For every item in the response, cache it as if it were a seperate search
      results.each do |listing|
        listing_query = listing_id_query_for(listing.id)
        listing_cache_key = cache_key_for(listing_query)
        Redis.current.setex(listing_cache_key, TTL, [listing].to_json)
      end
    end
    
    def clear_cache(query)
      cache_key = cache_key_for(query)
      Redis.current.del(cache_key)
    end

  end
end
