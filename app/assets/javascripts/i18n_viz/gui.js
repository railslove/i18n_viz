$(document).ready(function(){
  // append i18n tooltip
  $("body")
    .append('<div id="i18n-viz-tooltip">...</div>')
      .click(function() { $("#i18n-viz-tooltip").hide() })

  // enrich elements with i18n attributes, classes, tooltip events
  $.fn.initGUI = function(keys) {
    $(this)
      // tooltip events
      .mouseenter(function(){
        $tooltip = $("#i18n-viz-tooltip");
        
        var top = $(this).offset().top - $tooltip.outerHeight();
        var left = $(this).offset().left;
        if (top < 0) top = $(this).offset().top + $(this).height() + 10;
        
        $tooltip.html('');
        keys.forEach(function(value) {
          if (I18nViz.external_tool_url.length > 0) {
            $tooltip.append('<a href="' + I18nViz.external_tool_url + value + '" target="_blank">' + value + '</a>')
          } else {
            $tooltip.append("<span>"+value+"</span>")
          }
        });
        
        $tooltip
          .css({top: top, left: left})
          .show()
      })
  };

  // process elements with i18n strings in their text
  $(":i18n-el").each(function(){
    var $i18n_element = $(this);
    var i18n_keys     = extractI18nKeysFromText($i18n_element.text());

    $i18n_element.enrichWithI18nData(i18n_keys);
    $i18n_element.initGUI(i18n_keys)
    $i18n_element.clearI18nText();
  });
  
  // process elements with i18n strings in the value or placeholder attributes
  $("input:i18n-value").each(function(){
    var $i18n_input_element = $(this);
    var input_value         = $i18n_input_element.val();
    var placeholder_value   = $i18n_input_element.attr('placeholder');

    var i18n_keys = extractI18nKeysFromText(input_value + placeholder_value);

    $i18n_input_element.enrichWithI18nData(i18n_keys);
    
    // clear i18n data from value and placeholder attributes
    var cleared_input_value = input_value.replace(I18nViz.global_regex, "");
    $(this).val( cleared_input_value );
    if (placeholder_value) {
      var cleared_placeholder_value = placeholder_value.replace(I18nViz.global_regex, "");
      $(this).attr('placeholder', cleared_placeholder_value);
    }
  });  
})
