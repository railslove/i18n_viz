# extract i18n keys from a textnode (e.g. "translated text--en.translation.key--")
window.I18nViz.extractI18nKeysFromText = (text) ->
  keys = text.match(window.I18nViz.global_regex)
  if keys
    keys.forEach (value, index) -> keys[index] = value.replace(/--/g, "")
    keys
  else
    null

# enrich elements with i18n attributes, classes
$.fn.enrichWithI18nData = () ->
  $i18n_element = $(this)
  i18n_keys = window.I18nViz.extractI18nKeysFromText $i18n_element.text()
  if i18n_keys != null
    $i18n_element
      .addClass("i18n-viz")
      .data("i18n-keys", i18n_keys)
  $i18n_element

# clear i18n data from element text
$.fn.clearI18nText = () ->
  $(this).textNodes().each () ->
    $(this).replaceWith $(this).text().replace(I18nViz.global_regex, "")
  $(this)

# custom :i18n selectors
$.extend $.expr[':'], {
  'i18n-textnode': (el) ->
    window.I18nViz.regex.test $(el).textNodes().text()
  ,
  'i18n-value-placeholder': (el) ->
    (window.I18nViz.regex.test($(el).val()) || I18nViz.regex.test($(el).attr('placeholder')))
}