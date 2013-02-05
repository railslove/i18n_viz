$(document).ready () ->
  # append i18n tooltip
  $("body")
    .append('<div id="i18n_viz_tooltip">...</div>')
      .click () -> $("#i18n_viz_tooltip").hide()

  # enrich elements with i18n attributes, classes, tooltip events
  $.fn.initGUI = () ->
    $i18n_element = $(this)
    keys = $i18n_element.data("i18n-keys")
    $i18n_element
      # tooltip events
      .mouseenter () ->
        $tooltip = $("#i18n_viz_tooltip")

        top  = $i18n_element.offset().top - $tooltip.outerHeight()
        left = $i18n_element.offset().left
        if (top < 0)
          top = $i18n_element.offset().top + $i18n_element.height() + 10

        $tooltip.html('');
        keys.forEach (value) ->
          if (window.I18nViz.external_tool_url.length > 0)
            $tooltip.append('<a href="' + window.I18nViz.external_tool_url + value + '" target="_blank">' + value + '</a>')
          else
            $tooltip.append("<span>"+value+"</span>")

        $tooltip
          .css({top: top, left: left})
          .show()
    $i18n_element

  # process elements with i18n strings in their text
  $(":i18n-textnode").each () ->
    $(this)
      .enrichWithI18nData()
      .clearI18nText()
      .initGUI()

  # process elements with i18n strings in the value or placeholder attributes
  $("input:i18n-value-placeholder").each () ->
    $i18n_input_element = $(this)
    input_value         = $i18n_input_element.val()
    placeholder_value   = $i18n_input_element.attr('placeholder')

    $i18n_input_element.enrichWithI18nData()

    # clear i18n data from value and placeholder attributes
    cleared_input_value = input_value.replace(window.I18nViz.global_regex, "")
    $(this).val( cleared_input_value )
    if (placeholder_value)
      cleared_placeholder_value = placeholder_value.replace(window.I18nViz.global_regex, "")
      $(this).attr('placeholder', cleared_placeholder_value)
