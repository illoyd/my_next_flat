module MyNextFlat

  class ListingCache
  
    def self.listing(listing)
      key = cache_key(listing)
      data = $redis.get(key)
      data.blank? ? nil : deserialize( data )
    end
    
    def self.cache(listing)
      key = cache_key(listing)
      $redis.setex( key, default_ttl, serialize(listing) )
    end
    
    def self.cache_nil(listing_id)
      key = cache_key(listing_id)
      $redis.setex( key, nil_ttl, nil )
    end
    
    def self.cached?(listing)
      key = cache_key(listing)
      $redis.exists(key)
    end
    
    def self.cache_key(listing)
      "listing:#{ listing.try(:id) || listing }"
    end
    
    def self.default_ttl
      8.hours.seconds
    end
    
    def self.nil_ttl
      1.hour.seconds
    end
    
    def self.serialize(object)
#       return object.map{ |obj| serialize(obj) } if object.is_a?(Array)
      Zoopla::Listing.serialize(object)
    end
    
    def self.deserialize(value)
#       return value.map{ |val| deserialize(val) } if value.is_a?(Array)
      value.nil? ? nil : Zoopla::Listing.deserialize(value)
    end
  
  end

end
