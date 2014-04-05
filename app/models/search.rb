class Search < ActiveRecord::Base
  belongs_to :user,    inverse_of: :searches
  has_many :locations, inverse_of: :search, dependent: :destroy, autosave: true
  has_many :criterias, inverse_of: :search, dependent: :destroy, autosave: true
  has_many :alerts,    inverse_of: :search, dependent: :destroy, autosave: true
  
  accepts_nested_attributes_for :locations, :criterias, allow_destroy: true, reject_if: ->(nested){ nested.blank? }
  
  serialize :schedule, IceCube::Schedule
  
  after_initialize  :ensure_schedule
  before_validation :update_next_run_at
  
  validates_presence_of :name, :user
  validates :locations, associated: true, length: { minimum: 1, maximum: 10, too_short: "must have at least %{count} location", too_long: "may have at most %{count} locations" }
  validates :criterias, associated: true, length: { minimum: 1, maximum: 4, too_short: "must have at least %{count} criterion", too_long: "may have at most %{count} criteria"  }
  
  ##
  # Return the database column, or default to the last occurance of the schedule.
  def last_run_at
    super || self.schedule.try(:previous_occurrence)
  end

  ##
  # Filter an array of listings to remove any listings that have already been seen. This is determined
  # by checking if the listing was updated prior to the last execution time.
  def filter_listings(listings)
    cutoff_timestamp = self.last_run_at
    listings.reject { |ll| ll.updated_at < cutoff_timestamp }.sort_by(&:updated_at)
  end
  
  def combinations
    self.locations.product(self.criterias)
  end
  
  protected
  
  def ensure_schedule
    self.schedule ||= IceCube::Schedule.new
  end
  
  def update_next_run_at
    self.next_run_at = self.schedule.try(:next_occurrence)
  end
  
end
