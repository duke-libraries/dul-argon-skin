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
    $(this).toggleClass('shown');
    $('.barcode-wrapper').toggle();
  });


  /* enable tooltips*/
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  });

  /* When the Request button is clicked for a TRLN result, show */
  /* a modal with links to choose your home library. Add the    */
  /* corresponding ILLiad request parameters to those links.    */

  $(document).on("click", ".request-from-trln", function () {
    var illiad_params = $(this).data('illiad-params');
    $( "#choose-your-illiad a" ).each(function(){
      new_href = ($(this).data('base-url') + '?' + illiad_params);
      $(this).attr( "href", new_href );
    });
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
