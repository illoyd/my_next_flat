source 'https://rubygems.org'
ruby '2.1.0'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0.rc1'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

#
# Standard gems
gem 'haml'
gem 'api_smith'
gem 'ice_cube'
gem 'devise', '~> 3.2.0'
gem 'devise-async'
gem 'cancancan', '~> 1.7'

#
# Infrastructure gems
gem 'oj'
gem 'oj_mimic_json'
gem 'redis'
gem 'sidekiq'

#
# Miscelanious gems
gem 'uk_postcode'

#
# Test and development gems
group :test, :development do
  gem "rspec-rails" #, "~> 2.0"
	gem 'factory_girl'
	gem 'faker'
end

#
# Test gems
group :test do
  gem 'minitest'
	gem 'shoulda-matchers'
	gem 'rspec-sidekiq'
	gem 'vcr'
	gem 'webmock', "~> 1.11.0"
	gem 'fuubar'
  gem 'simplecov', :require => false
  gem 'hashdiff'
end

#
# Production gems
group :production do
  gem 'newrelic_rpm'
end
