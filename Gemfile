# define our source to loook for gems
source "http://ruby.taobao.org"

# declare the sinatra dependency
gem "sinatra", "~> 1.4.2"
gem "mongoid", ">= 3.0.5"
gem "unicorn"
gem "capistrano"
gem 'capistrano-ext'
gem 'rvm-capistrano'

# setup our test group and require rspec
group :test do
  gem "rspec"
end

# setup development group
group :development do
  gem "better_errors"
  gem "sinatra-reloader"
end

# require a relative gem version
gem "i18n", "~> 0.6"
