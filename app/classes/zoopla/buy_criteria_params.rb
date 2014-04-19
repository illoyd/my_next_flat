module Zoopla

  class BuyCriteriaParams < Zoopla::CriteriaParams
    property :listing_status, default: 'sale'
  end

end
