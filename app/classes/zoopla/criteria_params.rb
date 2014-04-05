module Zoopla

  class CriteriaParams < APISmith::Smash
    property :minimum_price, from: :min_price
    property :maximum_price, from: :max_price
                    
    property :minimum_beds,  from: :min_beds
    property :maximum_beds,  from: :max_beds
                    
    property :minimum_baths, from: :min_baths
    property :maximum_baths, from: :max_baths
  end

end
