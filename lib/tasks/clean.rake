namespace :clean do

  desc "Clean stale users"
  task users: :environment do
    CleanStaleGuestsJob.perform_async
  end

end
