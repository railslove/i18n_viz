module I18nViz
  mattr_accessor :external_tool_url, :enabled
  
  @@enabled = true
  
  def self.enabled?
    @@enabled
  end
end

require 'i18n_viz/view_helpers'
require 'i18n_viz/engine'

