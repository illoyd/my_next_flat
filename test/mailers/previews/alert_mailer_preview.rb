class AlertMailerPreview < ActionMailer::Preview
  def alert
    # Mock up some data for the preview
    search   = Search.last
    listings = Zoopla::CachedListings.new.search(search).sort_by(&:updated_at).reverse!

    # Return a Mail::Message here (but don't deliver it!)
    AlertMailer.alert_email(search, listings)
  end
end

