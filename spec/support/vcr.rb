require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.default_cassette_options = { :record => :once, match_requests_on: [:method, :uri, :query] }
  c.hook_into :webmock
  c.ignore_hosts 'us.signalcloudapp.com', 'eu.signalcloudapp.com', 'requestb.in'

  c.configure_rspec_metadata!

end
