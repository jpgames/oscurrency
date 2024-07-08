#!/usr/bin/ruby

source 'https://rubygems.org'
ruby "2.5.9"
gem 'rails', '5.1.5'
gem 'responders'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'pg', '0.19.0'
gem "unicorn"
gem "girl_friday"
gem "exception_notification"
gem "kgio"
gem "raindrops"
gem "unf"

gem "sass-rails", '5.0.6'
gem "uglifier", '>=1.3.0'
# gem 'jquery-ui-rails'

gem "coffee-rails"
gem "audited"
gem "acts_as_paranoid"
gem "acts_as_tree"
gem "uuid"

# gem 'jquery-rails'

#gem "rack", '= 1.2.2'   #Heroku seems to force this
gem 'dynamic_form'
gem "oauth", '0.4.4'

gem "feed-normalizer"
gem "textacular"

gem "aws-s3", git: "https://github.com/bartoszkopinski/aws-s3.git"
gem "fog-aws"
gem 'xmlrpc'
gem "carrierwave"
gem "rmagick", '2.16.0'
gem "json"
gem "geokit-rails", "2.2.0"

gem "will_paginate"
gem "aasm", '3.0.19'
gem "authlogic", '3.6.1'
gem "scrypt"
gem "cancancan", "1.16.0"
gem "dalli", "2.7.6"
gem "redcarpet"
gem 'syck'
gem 'rails_admin', '2.3.0'
gem 'safe_yaml'
gem "ar_after_transaction"
gem 'valid_email', :require => 'valid_email/email_validator'
gem "calendar_helper"
#gem "gibbon", :git => "git://github.com/amro/gibbon.git"
gem "bootstrap_form", git: 'https://github.com/herestomwiththeweather/bootstrap_form.git', branch: 'v1_0_patch_for_rails4_2'
gem 'test-unit'

group :development, :test do
  gem 'dotenv-rails'
  gem "rack"
  gem "rack-test"
  gem "awesome_print"
  gem "artifice"
  gem "opentransact"
  gem 'annotate'
  gem 'therubyracer'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'highline'
  gem 'git'
end

group :production do
  gem 'memcachier'
  gem 'rails_12factor'
end

group :test do
  gem "database_cleaner"
  gem "guard-spork"
  #gem "rspec-rails", "~> 2.13" # :lib => false unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
  gem "rspec-rails"
  gem "spork"
end
gem 'remotipart'

