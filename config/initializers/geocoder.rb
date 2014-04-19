Geocoder.configure(
  cache: $redis || Redis.new(uri: Rails.application.secrets.redis_url)
)
