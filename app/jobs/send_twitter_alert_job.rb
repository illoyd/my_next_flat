class SendTwitterAlertJob < SendAlertJob
  include Sidekiq::Worker

  def send_alert(search, listings)
    listings.each do |listing|
      message = listing_message(search, listing)
      logger.info "Twitter: #{ message }"
      $twitter.update(message)
    end
  end
  
  def listing_message(search, listing)
    listing_kind   = listing.kind || beds_for(listing)
    listing_status = listing.for_sale? ? 'for sale' : 'for rent'
    "@#{ search.user.twitter_handle } We found a #{ listing_kind.downcase } #{ listing_status } for #{ price_for(listing) }. #{ search_listing_url(search, listing.id, host: 'www.mynextflat.co.uk') }"
  end

end
