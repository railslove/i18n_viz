$(document).ready(function(){
  var i18n_regexp = new RegExp(/--([a-z0-9_\.]+)--/i);
  var i18n_regexp_global = new RegExp(/--([a-z0-9_\.]+)--/gi);
  
  // i18n tooltip
  $("body")
    .append('<div id="i18n-viz-tooltip">...</div>')
    .click(function() { $("#i18n-viz-tooltip").hide() })
  
  $.fn.textNodes = function() {
    return $(this).contents().filter(function(){ return this.nodeType == 3 });
  };
  
  // add i18n attributes, classes, events
  $.fn.addI18n = function(keys) {
    $(this)
      .addClass("i18n-viz")
      .data("i18n-keys", keys)
      
      .mouseenter(function(){
        $tooltip = $("#i18n-viz-tooltip");
        
        var top = $(this).offset().top - 40;
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
      .mouseleave(function() {
        setTimeout(function() { $("#i18n-viz-tooltip").fadeOut('fast'); }, 1500);
      });
  };
  
  function getI18nKeys(text) {
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

  $(":i18n-el").each(function(){
    var text = $(this).text();
    
    var keys = getI18nKeys(text);
    $(this).addI18n(keys);
    
    $(this).textNodes().each(function() { $(this).replaceWith( $(this).text().replace(i18n_regexp_global, "") ); })
  });
  
  $("input:i18n-value").each(function(){
    var value = $(this).val();
    var placeholder = $(this).attr('placeholder');
    var text = value + placeholder;
    
    var keys = getI18nKeys(text);
    $(this).addI18n(keys);
    
    $(this).val(value.replace(i18n_regexp_global, ""));
    if (placeholder) $(this).attr('placeholder', placeholder.replace(i18n_regexp_global, ""));
  });  
})

