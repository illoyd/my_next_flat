source 'https://rubygems.org'
ruby '2.1.4'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
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
gem 'haml-contrib'
gem 'hashie'
gem 'api_smith'
gem 'ice_cube'
gem 'recurring_select'
gem 'devise', '~> 3.4.0'
gem 'devise-async'
gem 'omniauth-twitter'
gem 'cancancan', '~> 1.9'
gem 'uk_postcode'
gem 'geocoder'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'twitter'
gem 'kaminari'

#
# Infrastructure gems
gem 'oj'
gem 'oj_mimic_json'
gem 'dalli'
gem 'redis'
gem 'redis-rails'
gem 'sidekiq', '~> 3.3'
# gem 'sidetiq', '~> 0.6'

#
# Dev and Prod gems
gem 'rails_12factor', group: [:development, :production]

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
	gem 'webmock', "~> 1.12.0"
	gem 'fuubar'
  gem 'simplecov', :require => false
  gem 'hashdiff'
end

#
# Production gems
group :production do
  gem 'newrelic_rpm'
  gem 'lograge'
end
