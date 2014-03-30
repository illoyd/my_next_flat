# Activate redis!
$redis = Redis.new(uri: Rails.application.secrets.redis_uri)
