class SendEmailAlertJob < SendAlertJob
  include Sidekiq::Worker

  def send_alert(search, listings)
    
  end

end
