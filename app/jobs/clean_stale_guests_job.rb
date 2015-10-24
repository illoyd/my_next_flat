class CleanStaleGuestsJob
  include Sidekiq::Worker

  def perform()
    User.guests.created_before('2 weeks').destroy_all
  end

end
