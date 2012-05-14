$(document).ready () ->
  # append i18n tooltip
  $("body")
    .append('<div id="i18n_viz_tooltip">...</div>')
      .click () -> $("#i18n_viz_tooltip").hide()

  # enrich elements with i18n attributes, classes, tooltip events
  $.fn.initGUI = (keys) ->
    $(this)
      # tooltip events
      .mouseenter () ->
        $tooltip = $("#i18n_viz_tooltip")
        
        top  = $(this).offset().top - $tooltip.outerHeight()
        left = $(this).offset().left
        if (top < 0)
          top = $(this).offset().top + $(this).height() + 10
        
        $tooltip.html('');
        keys.forEach (value) ->
          if (window.I18nViz.external_tool_url.length > 0)
            $tooltip.append('<a href="' + window.I18nViz.external_tool_url + value + '" target="_blank">' + value + '</a>')
          else
            $tooltip.append("<span>"+value+"</span>")
        
        $tooltip
          .css({top: top, left: left})
          .show()
    $(this)

  # process elements with i18n strings in their text
  $(":i18n-textnode").each () ->
    $i18n_textnode = $(this)
    i18n_keys      = window.I18nViz.extractI18nKeysFromText($i18n_textnode.text())

    $i18n_textnode
      .enrichWithI18nData(i18n_keys)
      .initGUI(i18n_keys)
      .clearI18nText()
  
  # process elements with i18n strings in the value or placeholder attributes
  $("input:i18n-value-placeholder").each () ->
    $i18n_input_element = $(this)
    input_value         = $i18n_input_element.val()
    placeholder_value   = $i18n_input_element.attr('placeholder')

    i18n_keys = window.I18nViz.extractI18nKeysFromText(input_value + placeholder_value)

    $i18n_input_element.enrichWithI18nData(i18n_keys)
    
    # clear i18n data from value and placeholder attributes
    cleared_input_value = input_value.replace(window.I18nViz.global_regex, "")
    $(this).val( cleared_input_value )
    if (placeholder_value)
      cleared_placeholder_value = placeholder_value.replace(window.I18nViz.global_regex, "")
      $(this).attr('placeholder', cleared_placeholder_value)
