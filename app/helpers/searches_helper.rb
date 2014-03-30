module SearchesHelper

  def options_for_location_types
    [ ['area', Location.name], ['postcode', PostcodeLocation.name], ['address', StreetLocation.name], ['coordinates', LatLonLocation.name] ]
  end
  
  def options_for_criteria_types
    [ ['buy', BuyCriteria.name], ['let', LetCriteria.name] ]
  end
  
  def options_for_radius
    [ 0, 0.25, 0.5, 0.75, 1, 2, 5, 10, 15, 25, 50 ].map{ |miles| [radius_for(miles), miles] }
  end
  
  def radius_for(radius)
    case radius
      when 0
        'in'
      else
        "within #{ number_to_fraction(radius, strip_insignificant_zeros: true) } #{ 'mile'.pluralize(radius) } of".html_safe
    end
  end
  
  def location_kind_for(location)
    case location
      when PostcodeLocation
        'postcode'
      when StreetLocation
        'address'
      when LatLonLocation
        'coordinates'
      else
        'area'
    end
  end

  def criteria_kind_for(criteria)
    case criteria
      when BuyCriteria
        'buy'
      when LetCriteria
        'let'
      else
        'buy or let'
    end
  end
  
  def status_for(status)
    case status
      when 'for_sale'
        'for sale'
      when 'to_rent'
        'to let'
      else
        status
    end
  end

end
