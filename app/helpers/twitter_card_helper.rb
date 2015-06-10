module TwitterCardHelper

  def twitter_title_for(listing)
    return nil unless listing
    beds   = beds_for(listing)
    baths  = baths_for(listing)
    kind   = listing.try(:kind).try(:downcase) || 'property'
    status = listing.for_sale? ? 'sale' : 'rent'
    "#{ beds } #{ baths } #{ kind } for #{ status }".strip.gsub(/ {2,}/, ' ').gsub(/(\b\w+\b)(?:\s*\1)+/, '\1')
  end

  def twitter_description_for(listing)
    description = listing.try(:summary) || listing.try(:description) || twitter_title_for(listing)
    truncate(description, length: 200, separator: ' ')
  end

  def twitter_creator_for(listing)
    "@zoopla"
  end

  def twitter_image_for(listing)
    listing.try(:image_url) || listing.try(:floorplan_url) || listing.try(:agent_logo_url) || nil
  end

end
