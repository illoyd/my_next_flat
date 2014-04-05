module Zoopla

  class CachedListings < Listings
  
    TTL = 24.hours.seconds

    def query(query, options = {})
      # Get cache if available 
      cached_results = get_cache(query, options)
      return cached_results if cached_results
      
      # Query via parent
      results = super(query, options)
      
      # Add to cache
      set_cache(query, options, results) unless results.try(:empty?)
      
      # Return results
      results
    end
    
    def cache_key_for(query, options={})
      query_terms = query.merge(options).with_indifferent_access
      query_terms.reject! { |k,v| v.nil? }
      'zoopla:listings:' + query_terms.keys.sort.map { |k| "#{ k }=#{ query_terms[k].to_s.downcase.gsub(/\s/,'') }" }.join(':')
    end

    def get_cache(query, options)
      cache_key = cache_key_for(query, options)
      $redis.exists(cache_key) ? Zoopla::Listing.call(JSON.parse($redis.get(cache_key))) : nil
    end
    
    def set_cache(query, options, results)
      cache_key = cache_key_for(query, options)
      $redis.setex(cache_key, TTL, results.to_json)
    end
    
    def clear_cache(query, options)
      cache_key = cache_key_for(query, options)
      $redis.del(cache_key)
    end

  end
end
