class Location < ActiveRecord::Base
  belongs_to :search, inverse_of: :locations
  
  validates_presence_of :area
  validates_numericality_of :radius

  def includes?(other)
    self.area.downcase.chomp == other.area.downcase.chomp &&
      self.radius >= other.radius
  end
  
  def blank?
    self.area.blank? && ( self.radius.blank? || self.radius.to_f == 0.0 )
  end

end
