class CleanStaleGuestsJob
  include Sidekiq::Worker

  def perform(search_id)
    User.guests.created_before('2 weeks').destroy_all
  end

end
