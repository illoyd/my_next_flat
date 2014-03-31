class PeriodicLondonSearchJob
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }

  NEIGHBOURHOODS = [ "Balham",
    "Battersea",
    "Belgravia",
    "Bermondsey",
    "Bethnal Green",
    "Bloomsbury",
    "Brixton",
    "Camden Town",
    "Canonbury",
    "Chelsea",
    "City of London",
    "Clapham",
    "Clerkenwell",
    "Covent Garden",
    "Earls Court",
    "Fitzrovia",
    "Fulham",
    "Greenwich",
    "Haggerston",
    "Hammersmith",
    "Isle of Dogs",
    "Islington",
    "Kennington",
    "Kensington",
    "Kings Cross",
    "Knightsbridge",
    "Lambeth",
    "Maida Vale",
    "Marylebone",
    "Mayfair",
    "Notting Hill",
    "Paddington",
    "Pimlico",
    "Shepherd's Bush",
    "Shoreditch",
    "Soho",
    "Somers Town",
    "South Bank",
    "Southwark",
    "Stepney",
    "St. James's",
    "St. Luke's",
    "Stockwell",
    # "The West End",
    "Walworth",
    "Westminster",
    "Whitechapel",
    "Bricklane",
    "Wimbledon" ]

  def perform()
    search(random_neighbourhood)
  end
  
  def search(neighborhood)
    search = build_search(neighborhood)

    # Perform search
    logger.info("Searching for #{ search.locations.first.area } using #{ search.id }...")
    results = self.service.search(search, { page_size: 25 })
    logger.info("  Found #{ results.size } listings!")
    
    # Clear cached results
    @service.clear(search)
  end
  
  def build_search(neighborhood)
    search = Search.new
    search.locations << Location.new( radius: 2, area: neighbourhood || self.random_neighbourhood )
    search.criterias << BuyCriteria.new( min_price: 25_000 )
    search.criterias << LetCriteria.new( min_price: 25 )
  end
  
  def random_neighbourhood
    NEIGHBOURHOODS.sample + ', London'
  end
  
  def all
    NEIGHBOURHOODS.shuffle.each { |neighbourhood| perform(neighbourhood + ', London') }
  end
  
  def service
    @service ||= MyNextFlat::CachedService.new
  end

end
