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

