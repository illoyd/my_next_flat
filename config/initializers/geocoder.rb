Geocoder.configure(
  ip_lookup: :telize
)

if Redis.current || ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"]
  Geocoder.configure(
    cache: Redis.current || Redis.new(:url => ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"])
  )
end
