namespace :clean do

  desc "Clean stale users"
  task users: :environment do
    CleanStaleUsersJob.perform_async
  end

end
