module I18nViz
  module ViewHelpers

    def translate(key, options = {}) # TODO: alias
      if display_i18n_viz? && options[:i18n_viz] != false
        "#{super(key, options)}--#{key}--"
      else
        super(key, options)
      end
    end
    alias :t :translate
    
    def i18n_viz_include_tag # TODO: doesn't work yet
      return unless display_i18n_viz?
      
      stylesheet_link_tag("i18n_viz")
      javascript_tag "var i18n_viz_key_url = '#{I18nViz.key_url}';"
      javascript_include_tag "i18n_viz"
    end

    def display_i18n_viz?
      I18nViz.enabled? && params && params[:i18n_viz]  rescue false  # rescue workaround, because params is weirdly defined in e.g. ActionMailer 
    end

  end
end
