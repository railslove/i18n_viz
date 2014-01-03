# get all the textnode children for an element
# edited
$.fn.textNodes = () ->
  try
    $(this).contents().filter () ->
      try
        (this.nodeType == 3)
      catch err
        false
  catch e
    []
