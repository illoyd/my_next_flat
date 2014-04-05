module Zoopla

  class Listings < API

    def find(id)
      query = listing_id_query_for(id)
      ListingsQuery.new(self).where(query).first
    end
    
    def search(search, extras = {})
      queries(search, extras).reduce(Set.new) { |memo,query| memo.merge(query(query)) }
    end
    
    def where(*components)
      ListingsQuery.new(self).where(*components)
    end

    def queries(search, extras = {})
      search.combinations.map { |combination| self.where(*combination).where(extras) }
    end
    
    def query(query)
      get "property_listings.json", extra_query: query, transform: Zoopla::Listing
    end
    
    def base_request_options
      { headers: { 'Accept' => 'application/json' } }
    end
    
    def base_query_options
      { order_by: 'age', ordering: 'descending', page_size: 25 }
    end
    
    def default_response_container(path, options)
      %w( listing )
    end
    
    def listing_id_query_for(id)
      { listing_id: id }
    end

  end
end
