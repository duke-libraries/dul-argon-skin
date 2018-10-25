$(document).ready(function() {
  /* DUL masthead primary navigation menu toggle */
  $('a#full-menu-toggle').on('click',function(e) {
    $(this).toggleClass('menu-active');
    $('#dul-masthead-region-megamenu').slideToggle();
  });

  $(".barcode-toggle").on("click",function(e) {

    var theBarcode = $(this).parents(".item").data("item-barcode");

    if (theBarcode) {
      $(this).next(".barcode-display").text(theBarcode);
      $(this).next(".barcode-display").toggle();

    } else {
      $(this).next(".barcode-display").text("no barcode");
      $(this).next(".barcode-display").toggle();
    }

  });

  $(document).bind('keypress', function(event) {
    if( event.which === 66 && event.shiftKey ) {
        $('.barcode-wrapper').toggle();
    }
  });

});
