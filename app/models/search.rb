class Search < Example
  belongs_to :user,    inverse_of: :searches

  serialize :schedule, IceCube::Schedule
  
  after_initialize  :ensure_schedule
  before_validation :update_next_run_at
  
  validates_presence_of :user

  validates :alert_method, inclusion: { in: %w( ignore twitter email ), allow_nil: true }

  validates :top_n, numericality: { integer_only: true, greater_than_or_equal_to: 1 }
  validates :top_n, numericality: { less_than_or_equal_to: 10 }, if: :alert_via_email?
  validates :top_n, numericality: { less_than_or_equal_to: 2 },  if: :alert_via_twitter?
  
  scope :should_alert, ->{ where( 'next_run_at <= NOW()' ).alertable }
  scope :alertable,    ->{ where(alert_method: %w( twitter email )) }
  
  DAILY         = -1
  WEEKDAY       = -2
  WEEKEND       = -3
  DAILY_VALUE   = (0..6).to_a
  WEEKDAY_VALUE = (1..5).to_a
  WEEKEND_VALUE = [0,6]
  
  DEFAULT_DAYS  = WEEKDAY
  DEFAULT_HOUR  = 8
  
  ##
  # Alert using email
  def alert_via_email?
    self.alert_method.inquiry.email?
  end
  
  ##
  # Alert using twitter
  def alert_via_twitter?
    self.alert_method.inquiry.twitter?
  end
  
  ##
  # Return only new listings.
  def new_listings
    ll = listings
    return ll if self.last_alerted_at.nil?
    ll.select { |listing| listing.updated_at >= self.last_alerted_at }
  end
  
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
  
  def day_of_week
    days = self.recurrence_rule.as_json.fetch('validations', {}).fetch('day', [])
    self.class.convert_ice_cube_days_to_day_of_week(days)
  end
  
  def day_of_week=(value)
    self.schedule = make_schedule( value, hour_of_day )
    self.schedule
  end
  
  def hour_of_day
    self.recurrence_rule.as_json.fetch('validations', {}).fetch('hour_of_day', []).first
  end
  
  def hour_of_day=(value)
    self.schedule = make_schedule( day_of_week, value )
    self.schedule
  end
  
  protected
  
  def recurrence_rule
    self.ensure_schedule
    self.schedule.recurrence_rules.first
  end
  
  def make_schedule(day = DEFAULT_DAYS, hour = DEFAULT_HOUR)
    day = self.class.convert_day_of_week_to_ice_cube_days(day)
    hour ||= DEFAULT_HOUR
    IceCube::Schedule.new.tap do |ss|
      ss.add_recurrence_rule(IceCube::Rule.weekly.day(day).hour_of_day(hour.to_i).minute_of_hour(0))
    end
  end
  
  def ensure_schedule
    self.schedule = make_schedule if self.schedule_before_type_cast.blank?
  end
  
  def update_next_run_at
    self.ensure_schedule
    self.next_run_at = self.schedule.try(:next_occurrence)
  end
  
  def self.convert_day_of_week_to_ice_cube_days(day_of_week)
    case day_of_week.to_i
      when WEEKDAY then WEEKDAY_VALUE
      when WEEKEND then WEEKEND_VALUE
      when 0..6    then [day_of_week.to_i]
      else
        DAILY_VALUE
    end
  end
  
  def self.convert_ice_cube_days_to_day_of_week(days)
    case days
      when DAILY_VALUE   then DAILY
      when WEEKDAY_VALUE then WEEKDAY
      when WEEKEND_VALUE then WEEKEND
      else
        days.first
    end
  end
  
end
