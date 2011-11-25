# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "i18n_viz"
  s.summary = "Insert I18nViz summary."
  s.description = "Insert I18nViz description."
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.version = "0.0.1"
end