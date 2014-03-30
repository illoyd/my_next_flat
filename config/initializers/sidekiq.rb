Sidekiq.configure_server do |config|
  config.redis = { :url => Rails.application.secrets.redis_uri, :namespace => 'sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => Rails.application.secrets.redis_uri, :namespace => 'sidekiq' }
end
