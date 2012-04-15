# enrich elements with i18n attributes, classes
$.fn.enrichWithI18nData = () ->
  i18n_keys = I18nViz.extractI18nKeysFromText $(this).text()
  if i18n_keys != null
    $(this)
      .addClass("i18n-viz")
      .data("i18n-keys", i18n_keys)
  $(this)

# clear i18n data from element text
$.fn.clearI18nText = () ->
  $(this).textNodes().each () ->
    $(this).replaceWith $(this).text().replace(I18nViz.global_regex, "")
  $(this)

# extract i18n keys from a textnode (e.g. "translated text--en.translation.key--")
I18nViz.extractI18nKeysFromText = (text) ->
  keys = text.match(I18nViz.global_regex)
  if keys
    keys.forEach (value, index) -> keys[index] = value.replace(/--/g, "")
    keys
  else
    null

# custom :i18n selectors
$.extend $.expr[':'], {
  'i18n-textnode': (el) ->
    I18nViz.regex.test $(el).textNodes().text()
  ,
  'i18n-value-placeholder': (el) ->
    (I18nViz.regex.test($(el).val()) || I18nViz.regex.test($(el).attr('placeholder')))
}