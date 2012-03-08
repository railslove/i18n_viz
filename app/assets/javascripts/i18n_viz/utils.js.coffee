# get all the textnode children for an element
# edited
$.fn.textNodes = () ->
  $(this).contents().filter () ->
    try
      (this.nodeType == 3)
    catch err
      false
