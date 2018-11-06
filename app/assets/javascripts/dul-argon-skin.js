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
  });

});


Blacklight.onLoad(function() {

  	$(window).load(function(){

      $('.document').each(function() {

        var hasRequest = $(this).has("div.index-document-functions").length;
        var hasWidth = $(this).children("div").find('img').get(0).naturalWidth;

        if (hasRequest && hasWidth > 2) {
          $(this).children(".documentHeader").addClass("has-request-and-thumbnail");
        }

        if (hasRequest && hasWidth < 2) {
          $(this).children(".documentHeader").addClass("has-request");
        }

        if (!hasRequest && hasWidth > 2) {
          $(this).children(".documentHeader").addClass("has-thumbnail");
        };

      });

    });

});
