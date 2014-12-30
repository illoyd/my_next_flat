module MyNextFlat

  class SearchResultCache
  
    def self.results(results)
      key = cache_key(results)
      deserialize( Redis.current.get(key) )
    end
    
    def self.cache(search, results)
      key = cache_key(search)
      
      # Save entire results to cache
      Redis.current.setex( key, default_ttl, serialize(results) )
      
      # Save individual items
      results.each { |listing| ListingCache.cache(listing) }
    end
    
    def self.clear(search)
      key = cache_key(search)
      Redis.current.del(key)
    end
    
    def self.cached?(search)
      key = cache_key(search)
      Redis.current.exists(key)
    end
    
    def self.cache_key(results)
      "results:#{ results.try(:id) || results }"
    end
    
    def self.default_ttl
      8.hours.seconds
    end
    
    def self.serialize(object)
      object.to_json
    end
    
    def self.deserialize(value)
      Zoopla::Listing.call( JSON.parse(value) )
    end
  
  end

end
