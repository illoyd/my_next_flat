json.array!(@searches) do |search|
  json.extract! search, :id, :name, :user_id
  json.url search_url(search, format: :json)
end
