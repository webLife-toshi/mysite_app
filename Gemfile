source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'bootstrap-sass', '2.1'
#これはhas_secure_passwordを利用するためのもの
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
#ページングに使うもの
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development, :test do
  gem 'sqlite3'
# rspecを動かすためには、group :development, testの中に定義する
  gem 'rspec-rails', '2.11.0'
end

group :development do
# データベースの内容を記述するもの
  gem 'annotate', '2.5.0'
end
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
# rspec-railsを動作させるのに必要
group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '4.1.0'
end
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
