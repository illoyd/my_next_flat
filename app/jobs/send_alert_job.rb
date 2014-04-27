# encoding: utf-8
class SendAlertJob
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  
  def perform(search_id)
    # Get the search and listings
    search = Search.find(search_id)
    
    # Abort if the next_run_at is in the future
    return if search.nil? || search.next_run_at > Time.now
    
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
      listings = search.new_listings.first(search.top_n)
    rescue Zoopla::Error => ex
      logger.error ex.message
      search.message = ex.message
      listings = []
    ensure
      search.last_alerted_at = Time.now
      search.save
    end
    
    listings
  end
  
end
