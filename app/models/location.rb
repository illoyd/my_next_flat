class Location < ActiveRecord::Base
  belongs_to :search, inverse_of: :locations
  
  validates_presence_of :area
  validates_numericality_of :radius
  
  geocoded_by :area
  after_commit :geocode_async, if: ->(obj){ obj.area_changed? || obj.previous_changes.include?(:area) }

  def includes?(other)
    self.area.downcase.chomp == other.area.downcase.chomp &&
      self.radius >= other.radius
  end
  
  def blank?
    self.area.blank? && ( self.radius.blank? || self.radius.to_f == 0.0 )
  end
  
  def geocode_async
    puts 'geocoding!'
    GeocodeLocationJob.perform_async(self.id) if self.id
    true
  end

end
