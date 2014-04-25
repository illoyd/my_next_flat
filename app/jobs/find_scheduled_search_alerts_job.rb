class FindScheduledSearchAlertsJob
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  
  recurrence { hourly } #.minute_of_hour(1, 15, 30, 45) }

  def perform
    Search.should_alert.each { |search| schedule_alert(search) }
  end
  
  def schedule_alert(search)
    case search.alert_method
      when 'twitter' then SendTwitterAlertJob.perform_async(search.id)
      when 'email'   then SendEmailAlertJob.perform_async(search.id)
    end
  end
  
end
