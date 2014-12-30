if ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"]
  Redis.current = Redis.new(:url => ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"])
end