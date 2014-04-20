# encoding: utf-8
class SendAlertJob
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  
  def perform(search_id)
    # Get the search and listings
    search = Search.find(search_id)
    
    # Abort if the next_run_at is in the future
    return if search.nil? #|| search.next_run_at > Time.now
    
    # Get all listings
    listings = find_listings(search)
    
    # Send the alert
    send_alert(search, listings)
    
    # Save it
    search.save
  end
  
  def find_listings(search)
    begin
      search.message = nil
      listings = Zoopla::CachedListings.new.search(search).sort_by(&:updated_at).reverse!
    rescue Zoopla::Error => ex
      logger.error ex.message
      search.message = ex.message
      listings = []
    ensure
      search.save
    end
    
    filter_listings(search, listings)
  end
  
  def filter_listings(search, listings)
    # Only select un-seen listings
    # TODO
  
    # Filter to the top N listings
    listings.first(search.top_n)
  end

  protected

  def beds_for(beds)
    beds = beds.try(:beds) || beds
    case beds
      when 0
        'studio'
      else
        pluralize(beds, 'bed')
    end
  end
  
  def number_to_sterling_buy(value)
    "£#{ value / 1_000 }k".html_safe
  end

  def number_to_sterling_let(value)
    "£#{ value }pcm".html_safe
  end
  
  def price_for(listing)
    price = number_to_price(listing.to_let? ? listing.price_per_calendar_month : listing.price, listing.to_let?)

    case listing.price_modifier
    when 'poa'                 then 'POA'
    when 'price_on_request'    then 'POR'
    when 'offers_over'         then "over #{price}"
    when 'from'                then "from #{price}"
    when 'offers_in_region_of' then "in region of #{price}"
    when 'part_buy_part_rent'  then "#{price} (part buy part rent)"
    when 'shared_equity'       then "#{price} (shared equity)"
    when 'shared_ownership'    then "#{price} (shared ownership)"
    when 'guide_price'         then "#{price} (guide)"
    when 'sale_by_tender'      then "#{price} by tender"
    else
      price
    end.html_safe
  end

  def number_to_price(price, to_let=false)
    to_let ? number_to_sterling_let(price) : number_to_sterling_buy(price)
  end
  
end
