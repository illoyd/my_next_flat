class GeocodeLocationJob
  include Sidekiq::Worker
  
  def perform(location_id)
    location = location_for(location_id)
    location.geocode
    location.save
  end
  
  def location_for(location_id)
    @location ||= Location.find(location_id)
  end

end
