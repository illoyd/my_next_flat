class Example < ActiveRecord::Base

  has_many :locations, inverse_of: :search, dependent: :destroy, autosave: true
  has_many :criterias, inverse_of: :search, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :locations, :criterias, allow_destroy: true, reject_if: ->(nested){ nested.blank? }
  
  validates_presence_of :name

  validates :locations, associated: true, length: { minimum: 1, maximum: 10, too_short: "must have at least %{count} location", too_long: "may have at most %{count} locations" }
  validates :criterias, associated: true, length: { minimum: 1, maximum: 4, too_short: "must have at least %{count} criterion", too_long: "may have at most %{count} criteria"  }
  
  ##
  # Scope only for examples
  scope :examples, -> { where(type: ['Example',nil]) }
  
  ##
  # Scope only for searches
  scope :searches, -> { where(type: 'Search') }
  
  ##
  # Get all listings from the providers.
  def listings
    Zoopla::CachedListings.new.search(self).sort_by(&:updated_at).reverse!
  end
  
  ##
  # Get a collection of possible searches using locations and criterias.
  def combinations
    self.locations.product(self.criterias)
  end
  
  ##
  # Copy this example as a new search for user
  def dup_as_search_for(user)
    Search.new.tap do |search|
      search.name = self.name
      search.user = user
      search.locations = self.locations.map { |ll| ll.dup }
      search.criterias = self.criterias.map { |cc| cc.dup }
      search.save
    end
  end
  
end
