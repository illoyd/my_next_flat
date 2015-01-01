namespace :data do

  desc "Load all London stations and tubes"
  task tubes: :environment do
    default_attributes = { kind: 'tfl_station' }
    YAML::load_file('./config/data/tubes.yml').each do |attributes|
      finder_attributes = default_attributes.merge({ name: attributes['name'] })
      poi = PointOfInterest.find_or_initialize_by(finder_attributes)
      puts "#{ poi.new_record? ? 'Creating' : 'Updating' } #{ attributes['name'] }."
      poi.update_attributes(default_attributes.merge(attributes))
      poi.save
    end
  end

  desc "TODO"
  task stations: :environment do
  end

end
