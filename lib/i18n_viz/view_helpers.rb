module I18nViz
  module ViewHelpers
    def translate(key, options = {}) # TODO: alias
      if display_i18n_viz? && options[:i18n_viz] != false
        # TODO: ActionController::Base.perform_caching = false  if ActionController::Base.perform_caching == true
        if !options[:scope].blank?
          "#{super(key, options)}--#{options[:scope]}.#{scope_key_by_partial(key)}--"
        else
          "#{super(key, options)}--#{scope_key_by_partial(key)}--"
        end
      else
        super(key, options)
      end
    end
    alias t translate

    def i18n_viz_include_tag # TODO: doesn't work yet
      return unless display_i18n_viz?

      stylesheet_link_tag 'i18n_viz'
      javascript_include_tag 'i18n_viz'
    end

    def display_i18n_viz?
      check_params
    rescue
      false # rescue workaround, because params is weirdly defined in e.g. ActionMailer
    end

    private

    def check_params
      return true if params && params[:i18n_viz]
      return true if cookies && cookies[:i18n_viz]
    end
  end
end
