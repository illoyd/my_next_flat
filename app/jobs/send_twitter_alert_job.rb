class SendTwitterAlertJob < SendAlertJob
  include Sidekiq::Worker
  include TwitterCardHelper
  
  TEMPLATES = [
    '@%{ username } We found a %{ title } for %{ price }. Nice! %{ url }',
    '@%{ username } We spotted a %{ title } for %{ price }. Looks nice! %{ url }',
    '@%{ username } Found a %{ title }, and just for %{ price }! %{ url }'
  ]

  def send_alert(search, listings)
    listings.each do |listing|
      message = compose_tweet(search, listing)
      logger.info "Twitter: #{ message }"
      $twitter.update(message)
    end
  end
  
  def compose_tweet(search, listing)
    TEMPLATES.sample % {
      username: search.user.twitter_handle,
      title:    twitter_title_for(listing),
      price:    price_for(listing),
      url:      search_listing_url(search, listing.id, host: 'www.mynextflat.co.uk')
    }
  end

end
