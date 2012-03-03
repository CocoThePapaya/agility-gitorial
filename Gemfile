source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
group :development do
  gem 'ruby-debug19'
end

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
gem "hobo_support", :path => "/work/hobo/hobo_support"
gem "hobo_fields", :path => "/work/hobo/hobo_fields"
gem "dryml", :path => "/work/hobo/dryml"
gem "hobo", :path => "/work/hobo/hobo"
gem "hobo_rapid", :path => "/work/hobo/hobo_rapid"
gem "hobo_clean", :path => "/work/hobo/hobo_clean"
gem "hobo_jquery", :path => "/work/hobo/hobo_jquery"

gem "bluecloth"
gem "RedCloth"

gem "shoulda", :group => :test
gem "factory_girl_rails", :group => :test

group :development, :test do
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'#, :ref => "83d8574c1d"  #"756ec1b2af70c66093c3b25976f520a3e6c3c2ae"
  gem 'capybara-webkit', :git => 'git://github.com/thoughtbot/capybara-webkit.git'
  gem 'database_cleaner'
end

gem "jquery-rails"

#gem "hobo-jquery", :git => "git://github.com/bryanlarsen/hobo-jquery.git", :branch => "no-prototype"

gem 'paperclip', :git => "git://github.com/jeanmartin/paperclip.git", :branch => "master"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'rails-dev-tweaks'
gem 'awesome_print'
