module I18nViz
  class Engine < ::Rails::Engine
    initializer "i18n_viz.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include I18nViz::ViewHelpers
      end
    end
  end
end
