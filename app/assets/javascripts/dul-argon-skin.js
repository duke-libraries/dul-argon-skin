$(document).ready(function() {

  /* DUL masthead primary navigation menu toggle */
  $('a#full-menu-toggle').on('click',function(e) {
    $(this).toggleClass('menu-active');
    $('#dul-masthead-region-megamenu').slideToggle();
  });


  /* display barcodes */
  $('.barcode-content').each(function() {
    var theBarcode = $(this).parents(".item").data("item-barcode");
    if (theBarcode) {
      $(this).text(theBarcode);
    } else {
      $(this).text("no barcode");
    }
  });

  $(".barcode-toggle").on("click",function(e) {
    e.preventDefault();
    $('.barcode-wrapper').toggle();
  });


  /* enable tooltips*/
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })

});
