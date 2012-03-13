module I18nViz
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../app/assets/", __FILE__)
      
      def copy_assets
        copy_file "javascripts/i18n_viz.js", "public/javascripts/i18n_viz.js"
        copy_file "stylesheets/i18n_viz.css", "public/stylesheets/i18n_viz.css"
      end
      
      def create_initializer
        initializer "i18n_viz.rb", %Q{
          I18nViz.enabled = !Rails.env.production?
          I18nViz.external_tool_url = "" # link to more information about each i18n key, e.g. "http://mytranslationtool.com/?key=" -- the key (e.g. 'en.foo.bar') will be appended to this URL
        }
      end
    end
  end
end
