# encoding: utf-8
if defined?(I18nViz)
  I18nViz.enabled = !Rails.env.production?
  #I18nViz.external_tool_url = "https://webtranslateit.com/en/projects/xxx/locales/en..de/strings?utf8=✓&s=" # link to more information about each i18n key, e.g. "http://mytranslationtool.com/?key=" -- the key (e.g. 'en.foo.bar') will be appended to this URL
end
