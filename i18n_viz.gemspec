$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "i18n_viz/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "i18n_viz"
  s.version     = I18nViz::VERSION
  s.authors     = ["Jakob Hilden"]
  s.email       = ["jakobhilden@gmail.com"]
  s.homepage    = "https://github.com/jhilden/i18n_viz"
  s.summary     = "Visualize i18n strings alongside their keys within the frontend of internationalized Rails/Ruby web applications."
  s.description = "I18nViz will help everyone to figure out where which i18n key is being used by adding a little overlay which can even link to any existing translation platform."

  s.files = Dir["{assets,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
end
