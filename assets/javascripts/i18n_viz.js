$.fn.textNodes = function() {

  var e;
  try {
    return $(this).contents().filter(function() {
      var err;
      try {
        return this.nodeType === 3;
      } catch (_error) {
        err = _error;
        return false;
      }
    });
  } catch (_error) {
    e = _error;
    return $([]);
  }
};

window.I18nViz.extractI18nKeysFromText = function(text) {
  var keys;
  keys = text.match(window.I18nViz.global_regex);
  if (keys) {
    keys.forEach(function(value, index) {
      return keys[index] = value.replace(/--/g, "");
    });
    return keys;
  } else {
    return null;
  }
};

$.fn.enrichWithI18nData = function() {
  var $i18n_element, i18n_keys;
  $i18n_element = $(this);
  i18n_keys = window.I18nViz.extractI18nKeysFromText($i18n_element.text());
  if (i18n_keys !== null) {
    $i18n_element.addClass("i18n-viz").data("i18n-keys", i18n_keys);
  }
  return $i18n_element;
};

$.fn.clearI18nText = function() {
  var $el;
  $el = $(this);
  $el.textNodes().each(function(index, node) {
    node.textContent = node.textContent.replace(I18nViz.global_regex, "");
  });
  return $el;
};

$.extend($.expr[':'], {
  'i18n-textnode': function(el) {
    return window.I18nViz.regex.test($(el).textNodes().text());
  },
  'i18n-value-placeholder': function(el) {
    return window.I18nViz.regex.test($(el).val()) || I18nViz.regex.test($(el).attr('placeholder'));
  }
});

$(document).ready(function() {
  $("body").append('<div id="i18n_viz_tooltip">...</div>').click(function() {
    return $("#i18n_viz_tooltip").hide();
  });
  $.fn.initGUI = function() {
    var $i18n_element, keys;
    $i18n_element = $(this);
    keys = $i18n_element.data("i18n-keys");
    $i18n_element.mouseenter(function() {
      var $tooltip, left, top;
      $tooltip = $("#i18n_viz_tooltip");
      top = $i18n_element.offset().top - $tooltip.outerHeight();
      left = $i18n_element.offset().left;
      if (top < 0) {
        top = $i18n_element.offset().top + $i18n_element.height() + 10;
      }
      $tooltip.html('');
      keys.forEach(function(value) {
        if (window.I18nViz.external_tool_url.length > 0) {
          return $tooltip.append('<a href="' + window.I18nViz.external_tool_url + value + '" target="_blank">' + value + '</a>');
        } else {
          return $tooltip.append("<span>" + value + "</span>");
        }
      });
      return $tooltip.css({
        top: top,
        left: left
      }).show();
    });
    return $i18n_element;
  };
  $(":i18n-textnode").each(function() {
    return $(this).enrichWithI18nData().clearI18nText().initGUI();
  });
  return $("input:i18n-value-placeholder").each(function() {
    var $i18n_input_element, cleared_input_value, cleared_placeholder_value, input_value, placeholder_value;
    $i18n_input_element = $(this);
    input_value = $i18n_input_element.val();
    placeholder_value = $i18n_input_element.attr('placeholder');
    $i18n_input_element.enrichWithI18nData();
    cleared_input_value = input_value.replace(window.I18nViz.global_regex, "");
    $(this).val(cleared_input_value);
    if (placeholder_value) {
      cleared_placeholder_value = placeholder_value.replace(window.I18nViz.global_regex, "");
      return $(this).attr('placeholder', cleared_placeholder_value);
    }
  });
});
