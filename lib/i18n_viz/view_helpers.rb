module I18nViz
  module ViewHelpers

    def translate(key, options = {}) # TODO: alias
      if display_i18n_viz? && options[:i18n_viz] != false
        # TODO: ActionController::Base.perform_caching = false  if ActionController::Base.perform_caching == true
        if !options[:scope].blank? 
          "#{super(key, options)}--#{options[:scope].to_s}.#{scope_key_by_partial(key)}--"
        else
          "#{super(key, options)}--#{scope_key_by_partial(key)}--"
        end
      else
        super(key, options)
      end
    end
    alias :t :translate
    
    def i18n_viz_include_tag # TODO: doesn't work yet
      return unless display_i18n_viz?
      
      stylesheet_link_tag("i18n_viz")
      javascript_include_tag "i18n_viz"
    end

    def display_i18n_viz?
      I18nViz.enabled? && params && params[:i18n_viz]  rescue false  # rescue workaround, because params is weirdly defined in e.g. ActionMailer 
    end

  end
end
