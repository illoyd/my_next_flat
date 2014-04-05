module Zoopla

  class Listings < API

    def find(id, options={})
      ListingsQuery.new(self).where({ listing_id: id }).first
    end
    
    def search(search, options={})
      search.combinations.reduce(Set.new) { |memo,combinations| memo.merge(self.where(*combinations).execute(options)) }.to_a
    end
    
    def where(*components)
      ListingsQuery.new(self).where(*components)
    end

    def query( query, options = {} )
      get "property_listings.json", extra_query: query.merge(options), transform: Zoopla::Listing
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
    
  end
end
