class SearchJob
  include Sidekiq::Worker

  def perform(search_id)
    search = Search.find(search_id)
    
    # Has this search already been run recently?
    
    # Perform search
    results = Zoopla::Service.new.search(search)

    # Send email!
  end

end
