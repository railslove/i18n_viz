## master

* change of plans :) no, really the complete installation has changed, this is
now a middleware which takes care of all the css and js injection and only does
this when `i18n_viz` is in the query string.
* [improvement] added `I18nViz.css_override` setting
* [improvement] added the ability to use a `i18n_viz` cookie

## 0.4.0

* [bugfix] tooltip displays correct key for translations that are using :scope option
* [bugfix] catch error when contents method raises exception
* [improvement] update test app routes to work with rails 4

## 0.3.2

* [bugfix] i18n key meta information wasn't cleared correctly from element's text
* [bugfix] problem with UTF-8 encoded `I18nViz.external_tool_url`, thanks to @eduoard
* [improvement] CSS tooltip text legibility, @eduoard

## 0.3.1

minor bugfixes in the JavaScrit and CSS

## 0.3.0

* The gem is now a Rails Engine and is targeted to work mostly with Rails versions 3.1+
* Switched to CoffeeScript
* Renamed `I18nViz.key_url` to `I18nViz.external_tool_url`

## 0.0.2

minor bugfixes

## 0.0.1

initial Version
