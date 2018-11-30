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



  /* UPDATE AVAILABILITY */
  /* uses request app API */

  /* if this is a show page */
  if ( $('body').hasClass('blacklight-catalog-show') ) {
    var document_id = $( "#document div:first-child" ).attr('id').replace(/\D/g,'');
    /* only run call if there is a current status */
    if ($('.status-label').length > 0) {
      get_the_availability(document_id);
    }
  };

  /* if this is a results page */
  if ( $('body').hasClass('blacklight-catalog-index') ) {
    $('.document').each(function() {
      var document_id = $( this ).find( "h3.index_title a" ).attr('href').replace(/\D/g,'');
      /* only run call if there is a current status */
      if ($( this ).find('.status-label').length > 0) {
        get_the_availability(document_id);
      }
    });
  };

  function escape_id( the_id ) {
    return the_id.replace( /(:|\.|\[|\]|,|=|@|\/|\&|\$|\%|\+)/g, "\\$1" );
  }

  /* API call function */
  /* needs a document_id, makes api call, updates DOM */

  function get_the_availability(document_id) {

    var api_url = 'https://requests.library.duke.edu/circstatus/';

    var xmlhttp = new XMLHttpRequest();

    xmlhttp.onreadystatechange = function() {

      if (this.readyState == 4 && this.status == 200) {
        var availability_response = JSON.parse(this.responseText);

        /* API returns itemID (as id) => [ label (as status.label), available (as status.available) ] */
        $.each(availability_response, function(id, status) {

          //var myDiv = $("div").find(`[data-item-barcode='${id}']`);
          var mySpan = $( "#item-" + escape_id(id) + " dl dd span" );

          // error handling for non-matching items
          if (mySpan.text() == "") {
            return true;
          } else {

            /* update status text */
            if ((mySpan.text()).trim() !== (status.label).trim()) {

              mySpan
                // uses velocity.js for fade animation (much faster than jquery)
                .velocity("fadeOut", {
                  duration: 500,
                  complete: function() {
                    mySpan.text(status.label)
                  }
                })
                .velocity("fadeIn", { delay: 250, duration: 500 });
            }

            /* update status class */
            switch (status.available) {
              case 'yes':
                if ( (mySpan.attr('class')).trim() != 'item-available' ) {
                  mySpan.attr('class', 'item-available');
                }
                break;
              case 'no':
                if ( (mySpan.attr('class')).trim() != 'item-not-available' ) {
                  mySpan.attr('class', 'item-not-available');
                }
                break;
              case 'other':
                if ( (mySpan.attr('class')).trim() != 'item-availability-misc' ) {
                  mySpan.attr('class', 'item-availability-misc');
                }
                break;
            }

          }

        });
      };

    };

    xmlhttp.open("GET", api_url + document_id, true);
    xmlhttp.send();

  };

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
