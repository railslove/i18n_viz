source "http://rubygems.org"

# Declare your gem's dependencies in i18n_viz.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :test do
  gem "rake"
  gem "tzinfo"

  # used by the dummy application
  gem "rails"
  gem "jquery-rails"
  gem "coffee-script"

  gem "evergreen"

  # testing libraries
  gem "capybara"
end

group :assets do
  gem 'therubyracer'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development do
  gem "launchy" # debugging
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.