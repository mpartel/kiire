source 'https://rubygems.org'

gem 'rails', '~> 3.2.11'
gem 'sqlite3'
gem 'jquery-rails'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'libv8', '3.11.8.11', :platforms => :ruby # Explicit dep until https://github.com/cowboyd/therubyracer/issues/189 is resolved

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'launchy'  # for save_and_open_page in capybara
  gem 'capybara'
  gem 'database_cleaner'
end
