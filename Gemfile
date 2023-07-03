source 'https://rubygems.org'
ruby '3.0.1'

# Backend
gem 'rails', '7.0.1' # Latest stable
gem 'pg' # Use Postgresql as database
gem 'puma' # Use Puma as the app server
gem 'mini_magick' # A ruby wrapper for ImageMagick or GraphicsMagick command line
gem 'pagy' # A pagination gem that is very light and fast
gem 'discard' # Soft deletes for ActiveRecord
gem 'sidekiq' # background processing for Ruby
gem 'sassc' # bootsnap dependency
gem 'bootsnap', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'jsonapi-serializer' # JSON: API serializer for Ruby
gem 'httparty' # A library to make http request easier
# gem 'jbuilder' # Build JSON APIs with ease
# gem 'redis' # Use Redis adapter to run Action Cable in production
# gem 'kredis' # Use Kredis to get higher-level data types in Redis
# gem 'bcrypt' # Use Active Model has_secure_password

# Authentications & Authorizations
gem 'devise' # Authentication solution for Rails with Warden
gem 'pundit' # Minimal authorization through OO design and pure Ruby classes
gem 'doorkeeper' # OAuth 2 provider functionality to Ruby on Rails
gem 'omniauth-google-oauth2' # OAuth 2 for Google
gem 'doorkeeper-grants_assertion' # 3rd party assertion grant extension for Doorkeeper
gem 'omniauth-rails_csrf_protection' # mitigation against OmniAuth Cross-Site Request Forgery

# Translations
# gem 'devise-i18n' # Translations for Devise
gem 'rails-i18n' # Translations for Rails
# gem 'devise-i18n' # Translations for Devise

group :development do
  gem 'foreman' # Manage Procfile-based applications
  gem 'better_errors' # Better error page for Rails and other Rack apps
  gem 'binding_of_caller' # Retrieve the binding of a method's caller in MRI 1.9.2+
  gem 'awesome_print' # Pretty print your Ruby objects with style -- in full color and with proper indentation
  gem 'roadie-rails' # Mailers
  gem 'spring' # Spring speeds up development by keeping your application running in the background.
  gem 'spring-commands-rspec' # This gem implements the rspec command for Spring.
  gem 'spring-watcher-listen', '2.0.1' # Makes Spring watch the filesystem for changes using Listen
end

group :development, :test do
  # Debugging
  gem 'pry-rails' # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug' # Step by step debugging and stack navigation in Pry
  # gem 'debug', platforms: %i[ mri mingw x64_mingw ] # Official debug

  # Utilities
  gem 'figaro' # Simple Rails app configuration
  gem 'listen' # Listens to file modifications
  gem 'letter_opener' # Preview mail in the browser instead of sending
  gem 'ffaker' # A library for generating fake data such as names, addresses, and phone numbers
  gem 'faker' # A library for generating more fake data
  gem 'fabrication' # Fabrication generates objects in Ruby. Fabricators are schematics for your objects, and can be created as needed anywhere in your app or specs

  # Testing
  gem 'rspec-rails', '~> 6.0' # Rails testing engine

  # Code Analysis
  gem 'bullet' # help to kill N+1 queries and unused eager loading
  gem 'brakeman', require: false # A static analysis security vulnerability scanner for Ruby on Rails applications
  gem 'parser', '3.0.1.1' # Use correct parser version to avoid parser warnings
  gem 'rubocop', require: false # A Ruby static code analyzer and formatter, based on the community Ruby style guide.
  gem 'rubocop-rails', require: false # A RuboCop extension focused on enforcing Rails best practices and coding conventions.
  gem 'rubocop-rspec', require: false # Code style checking for RSpec files
  gem 'rubocop-performance', require: false # An extension of RuboCop focused on code performance checks.
  gem 'undercover' # Report missing test coverage in new changes
  gem 'danger' # Automated code review.
  gem 'danger-rubocop' # A Danger plugin for Rubocop.
  gem 'danger-reek' # Detect code smell.
  gem 'danger-brakeman_scanner' # Security static analysis scanner in danger.
  gem 'danger-suggester' # Suggest code changes based on configured code formatter.
  gem 'danger-simplecov_json' # Report your Ruby app test suite code coverage in Danger.
  gem 'danger-undercover' # Report missing test coverage of new changes in Danger
end

group :test do
  gem 'rspec-retry' # Retry randomly failing rspec example.
  gem 'database_cleaner' # Use Database Cleaner
  gem 'shoulda-matchers' # Tests common Rails functionalities
  gem 'json_matchers' # Validate the JSON returned by your Rails JSON APIs
  gem 'webmock' # Library for stubbing and setting expectations on HTTP requests in Ruby
  gem 'simplecov', require: false # code coverage analysis tool for Ruby
  gem 'simplecov-json', require: false # JSON formatter for simplecov
  gem 'simplecov-lcov', require: false # LCOV report for undercover
  gem 'vcr' # Gem for recording test suite's HTTP interactions
  gem 'timecop' # Gem for time travel
  gem 'rails-controller-testing' # Gem that allow to use assigns as well ass assert_template
  gem 'pundit-matchers' # Rspec matcher for testing Pundit
end

group :production do
  gem 'rack-timeout' # Rack middleware which aborts requests that have been running for longer than a specified timeout.
end
