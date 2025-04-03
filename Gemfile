source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1', '>= 8.0.1'

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5.6'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.4', '>= 6.4.2'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
gem 'devise'
gem 'devise-jwt'
gem 'rack-cors'
gem 'dotenv-rails', groups: [:development, :test]
gem 'mini_magick'
gem 'image_processing', '~> 1.2'
gem 'link_thumbnailer'
gem 'acts_as_votable'
gem 'aws-sdk', '~> 3.0', '>= 3.0.1', require: false
gem 'trix'
gem 'friendly_id', '~> 5.4.0'
gem 'public_suffix'
gem 'rswag'
gem 'swagger-docs'
gem 'yaml_db'
gem 'figaro'
# Gemfile
gem 'letter_opener', group: :development
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

gem "rspec-rails"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :production do
  gem 'pg'
  gem 'rails_12factor', '0.0.2'
end


gem "ruby-lsp", "~> 0.0.2", :group => :development
