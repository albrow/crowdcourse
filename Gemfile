source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'bootstrap-sass', '2.0.0'
gem 'jquery-rails'
gem 'bcrypt-ruby'
gem 'devise'
gem 'activeadmin'

gem 'vimeo', :path => 'vendor/gems/' # using a local copy to fix a bug in the official gem release
gem 'delayed_job_active_record' # queueing bg tasks for worker dynos
gem 'aws-sdk' # retrieving files from s3
gem 's3_swf_upload' # for direct uploads to s3

gem 'pg'
gem 'pg_search' # full text search (postgres only)

gem 'omniauth-facebook', '1.4.0' # for facebook signin; the newest version causes csrf bug
gem 'koala' # for connecting with facebook graph API. Mostly for profile pictures

gem 'numbers_and_words' # for converting numbers to words, e.g. 1 to one

group :development, :test do
  gem 'rspec-rails', '2.9.0'
  gem 'annotate', '~> 2.4.1.beta' # automatically annotates models with schema info
  gem 'railroady' # for schema visualization

  gem 'guard' # command line tool for automatically doing shit (i.e. refresh browser when you change a view)
  gem 'growl' # growl notifications for guard
  gem 'guard-annotate' # update annotations when you change the database
  gem 'guard-livereload' # refresh the browser when a view is updated
  gem 'yajl-ruby' # optional add-on for livereload. Speeds up json
  gem 'rack-livereload'
  gem 'rb-fsevent', '~> 0.9.1'
end

group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '1.4.0'
end

group :production, :staging do
  gem 'unicorn'
end

group :production do
  gem 'newrelic_rpm' # newrelic monitoring (includes availability which prevents dyno spin-down)
  gem 'thin'
end