module MyNextFlat

  class Listing
  
    def cache_key
      "listing:#{ id }"
    end

  end

end
