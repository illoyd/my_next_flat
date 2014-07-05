# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# user1 = User.create!(name: Faker::Name.first_name, email: 'ian@signalcloudapp.com', password: 'test1234', password_confirmation: 'test1234')

# Precompile city-level searches
[ 'London, England', 'Birmingham, England', 'Edinburgh, Scotland', 'Glasgow, Scotland', 'Cardiff City Centre, Wales', 'Bristol, England' ].each do |area|
  Example.find_or_create_by(name: area) do |example|
    example.locations << Location.new(area: area, radius: 2.0)
    example.criterias << BuyCriteria.new
    example.criterias << LetCriteria.new
  end
end

[ 'Balham, London', 'Battersea, London', 'Belgravia, London', 'Bermondsey, London', 'Bethnal Green, London', 'Bloomsbury, London',
  'Brixton, London', 'Camden Town, London', 'Canonbury, London', 'Chelsea, London', 'City of London, London', 'Clapham, London',
  'Clerkenwell, London', 'Covent Garden, London', 'Earls Court, London', 'Fitzrovia, London', 'Fulham, London', 'Greenwich, London',
  'Haggerston, London', 'Hammersmith, London', 'Isle of Dogs, London', 'Islington, London', 'Kennington, London', 'Kensington, London',
  'Kings Cross, London', 'Knightsbridge, London', 'Lambeth, London', 'Maida Vale, London', 'Marylebone, London', 'Mayfair, London',
  'Notting Hill, London', 'Paddington, London', 'Pimlico, London', 'Shepherd\'s Bush, London', 'Shoreditch, London', 'Soho, London',
  'Somers Town, London', 'South Bank, London', 'Southwark, London', 'Stepney, London', 'St. James\'s, London', 'St. Luke\'s, London',
  'Stockwell, London', 'The West End, London', 'Walworth, London', 'Westminster, London', 'Whitechapel/Brick Lane, London', 
  'Wimbledon, London' ].each do |area|

  Example.find_or_create_by(name: area) do |example|
    example.locations << Location.new(area: area, radius: 0.25)
    example.criterias << BuyCriteria.new
    example.criterias << LetCriteria.new
  end
end