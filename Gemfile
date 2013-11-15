source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.1'
gem 'bcrypt-ruby', '~> 3.1.2' # Use ActiveModel has_secure_password
gem 'chronic'
gem 'gmaps4rails'
gem 'httparty'
gem 'rails_autolink'
gem 'public_activity', '~> 1.4.0'
gem 'thin' # Use thin as the app server
gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails', github: 'anjlab/bootstrap-rails'
gem 'meta-tags', require: 'meta_tags'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# gem 'jquery-ui-rails'

# group :assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'haml'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  # use postgreSQL as the database for Active Record
  gem 'pg'
  gem 'rails_12factor'
end

group :development do
  # allow the annotation of models with bundle exec annotate
  gem 'annotate'
  # use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby