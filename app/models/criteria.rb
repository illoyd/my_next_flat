class Criteria < ActiveRecord::Base
  belongs_to :search, inverse_of: :criterias
  
  before_validation :clean_prices
  
  validates_numericality_of :min_price, :max_price, allow_nil: true, greater_than_or_equal_to: 0
  validates_numericality_of :min_price, allow_nil: true, less_than_or_equal_to: :max_price, if: :max_price?
  validates_numericality_of :max_price, allow_nil: true, greater_than_or_equal_to: :min_price, if: :min_price?
  
  validates_numericality_of :min_beds, :max_beds, only_integer: true, allow_nil: true, greater_than_or_equal_to: 0
  validates_numericality_of :min_beds, allow_nil: true, less_than_or_equal_to: :max_beds, greater_than_or_equal_to: 0, if: :max_beds?
  validates_numericality_of :max_beds, allow_nil: true, greater_than_or_equal_to: :min_beds, if: :min_beds?
  
  validates_numericality_of :min_baths, :max_price, only_integer: true, allow_nil: true, greater_than_or_equal_to: 0
  validates_numericality_of :min_baths, allow_nil: true, less_than_or_equal_to: :max_baths, if: :max_baths?
  validates_numericality_of :max_baths, allow_nil: true, greater_than_or_equal_to: :min_baths, if: :min_baths?
  
  def price_range
    (self.min_price || 0)..(self.max_price || Float::INFINITY)
  end
  
  def beds_range
    (min_beds || 0)..(max_beds || Float::INFINITY)
  end
  
  def baths_range
    (min_baths || 0)..(max_baths || Float::INFINITY)
  end
  
  def prices?
    self.min_price || self.max_price
  end
  
  def beds?
    self.min_beds || self.max_beds
  end
  
  def baths?
    self.min_baths || self.max_baths
  end
  
  def includes?(other)
    self.type == other.type &&
      self.price_range.include?(other.price_range) &&
      self.beds_range.include?(other.beds_range) &&
      self.baths_range.include?(other.baths_range)
  end
  
  def blank?
    self.min_price.blank? &&
      self.max_price.blank? &&
      self.min_beds.blank? &&
      self.max_beds.blank? &&
      self.min_baths.blank? &&
      self.max_baths.blank?
  end
  
  def to_let?
    self.is_a?(LetCriteria)
  end
  
  def to_buy?
    self.is_a?(BuyCriteria)
  end
  
  protected
  
  def clean_prices
    self.min_price.gsub!(/\D/i, '') if self.min_price.respond_to?(:gsub!)
    self.max_price.gsub!(/\D/i, '') if self.max_price.respond_to?(:gsub!)
  end

end
