class PostcodeLocation < Location

  validates :area, presence: true, postcode: true

  before_validation :clean_area
  after_validation :format_area
  
  protected
  
  def clean_area
    self.area.gsub!(/\s/, '')
  end
  
  def format_area
    self.area = UKPostcode.new(self.area).norm
  end

end
