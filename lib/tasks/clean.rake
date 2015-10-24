namespace :clean do

  desc "Clean stale users"
  task users: :environment do
    CleanStaleUsersJob.new.perform
  end

end
