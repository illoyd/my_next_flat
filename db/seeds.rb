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
