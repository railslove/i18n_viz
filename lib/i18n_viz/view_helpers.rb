module I18nViz
  module ViewHelpers
    #module InstanceMethods
      
      def t(key, options = {}) # TODO: alias
        if I18nViz.enabled? && options[:i18n_viz] != false
          # TODO: only show i18n_viz if params[:i18n_viz] == true
          "#{super(key, options)}--#{key}--"
        else
          super(key, options)
        end
      end
      
      def i18n_viz_include_tag # TODO: doesn't work yet
        return unless I18nViz.enabled?
        
        stylesheet_link_tag "i18n_viz"
        javascript_tag "var i18n_viz_key_url = '#{I18nViz.key_url}';"
        javascript_include_tag "i18n_viz"
      end
    #end
  end
end
