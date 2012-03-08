// enrich elements with i18n attributes, classes
$.fn.enrichWithI18nData = function(i18n_keys) {
  $(this)
    .addClass("i18n-viz")
    .data("i18n-keys", i18n_keys);
};

// clear i18n data from element text
$.fn.clearI18nText = function() {
  $(this).textNodes().each(function() {
    $(this).replaceWith( $(this).text().replace(I18nViz.global_regex, "") );
  })
};

// extract i18n keys from a textnode (e.g. "translated text--en.translation.key--")
function extractI18nKeysFromText(text) {
  var keys = text.match(I18nViz.global_regex);
  keys.forEach(function(value, index) { keys[index] = value.replace(/--/g, "") });
  return keys;
}

// custom :i18n selectors
$.extend($.expr[':'], {
  'i18n-el': function (el) {
    return I18nViz.regex.test( $(el).textNodes().text() );
  },
  'i18n-value': function (el) {
    return (I18nViz.regex.test($(el).val()) || I18nViz.regex.test($(el).attr('placeholder')));
  }
});