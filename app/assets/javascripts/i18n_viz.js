$(document).ready(function(){
  var i18n_regexp        = new RegExp(/--([a-z0-9_\.]+)--/i);
  var i18n_regexp_global = new RegExp(/--([a-z0-9_\.]+)--/gi);

  // append i18n tooltip
  $("body")
    .append('<div id="i18n-viz-tooltip">...</div>')
      .click(function() { $("#i18n-viz-tooltip").hide() })

  // get all the textnode children for an element
  $.fn.textNodes = function() {
    return $(this).contents().filter(function(){
      try {
        return (this.nodeType == 3);
      } catch(err) {
        return false;
      }
    });
  };

  // enrich elements with i18n attributes, classes, tooltip events
  $.fn.enrichWithI18nData = function(keys) {
    $(this)
      .addClass("i18n-viz")
      .data("i18n-keys", keys)
      
      // tooltip events
      .mouseenter(function(){
        $tooltip = $("#i18n-viz-tooltip");
        
        var top = $(this).offset().top - $tooltip.outerHeight();
        var left = $(this).offset().left;
        if (top < 0) top = $(this).offset().top + $(this).height() + 10;
        
        $tooltip.html('');
        keys.forEach(function(value) {
          if (i18n_viz_key_url) {
            $tooltip.append('<a href="'+i18n_viz_key_url+value+'" target="_blank">'+value+'</a>')
          } else {
            $tooltip.append("<span>"+value+"</span>")
          }
        });
        
        $tooltip
          .css({top: top, left: left})
          .show()
      })
  };
  
  // extract i18n keys from a textnode (e.g. "translated text--en.translation.key--")
  function extractI18nKeys(text) {
    var keys = text.match(i18n_regexp_global);
    keys.forEach(function(value, index) { keys[index] = value.replace(/--/g, "") });
    return keys;
  }

  // build custom :i18n selectors
  $.extend($.expr[':'], {
    'i18n-el': function (el) {
      return i18n_regexp.test( $(el).textNodes().text() );
    },
    'i18n-value': function (el) {
      return (i18n_regexp.test($(el).val()) || i18n_regexp.test($(el).attr('placeholder')))
    }
  });

  // process elements with i18n strings in their text
  $(":i18n-el").each(function(){
    var text = $(this).text();
    
    var keys = extractI18nKeys(text);
    $(this).enrichWithI18nData(keys);
    
    // clear i18n data from text
    $(this).textNodes().each(function() {
      $(this).replaceWith( $(this).text().replace(i18n_regexp_global, "") );
    })
  });
  
  // process elements with i18n strings in the value or placeholder attributes
  $("input:i18n-value").each(function(){
    var value             = $(this).val();
    var placeholder_value = $(this).attr('placeholder');

    var keys = extractI18nKeys(value + placeholder_value);
    $(this).enrichWithI18nData(keys);
    
    // clear i18n data from value and placeholder attributes
    $(this).val(value.replace(i18n_regexp_global, ""));
    if (placeholder_value)  $(this).attr('placeholder', placeholder_value.replace(i18n_regexp_global, ""));
  });  
})

