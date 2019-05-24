$(document).ready(function() {

  /* Strip ids from document tools links, e.g., <a id="emailLink">. */
  /* DUL renders those multiple times per page (esp. for mobile).   */
  /* It's invalid HTML & is flagged as an accessibility violation.  */
  $('.doc-tools a').attr('id','');

  /* Ensure the sticky item show sidebar (using BS affix.js) doesn't */
  /* bleed into the footer when at the bottom of the content section */

  function sticky_relocate() {
    var window_top = $(window).scrollTop();
    var footer_top = $("#footer").offset().top;
    var div_top = $('#show-sidebar-inner').offset().top;
    var div_height = $("#show-sidebar-inner").height();
    var padding = 20;

    if (window_top + div_height > footer_top - padding) {
      $('#show-sidebar-inner').css({
        top: (window_top + div_height - footer_top + padding) * -1
      });
    } else {
      $('#show-sidebar-inner').css({
        top: 0
      });
    }

  }

  /* If it's an item show page w/sidebar, activate stickiness and scrollspy */
  if($('#show-sidebar').length) {
    /* Ensure the sidebar gets un/stuck correctly upon initial page load, */
    /* scroll, and viewport resize events */
    $( window ).scroll(sticky_relocate);
    $( window ).resize(sticky_relocate);
    sticky_relocate();

    $('body').scrollspy({
      target: '#show-sidebar-inner',
      offset: 30
    });
  }

  // Smooth scroll to all anchors, esp. useful for sidebar menu
  $('a[href*="#"]:not([href="#"]):not([data-toggle]):not(".btn-hide")').click(function() {
      if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'')
          || location.hostname == this.hostname) {

          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top
                }, 500);
                return false;
          }
      }
  });

  // Smooth scroll to top
  $('a.back-to-top').click(function() {
    $('html,body').animate({
        scrollTop: 0
    }, 500);
    return false;
  });


  /* DUL masthead primary navigation menu toggle */
  $('a#full-menu-toggle').on('click',function(e) {
    e.preventDefault();
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

  /* Toggle staff view: show barcodes, etc. */
  $(".staff-view-toggle").on("click",function(e) {
    e.preventDefault();
    $(this).toggleClass('shown');
    $(this).closest('.items').find('.barcode-wrapper').fadeToggle();
  });


  /* position tooltips */
  $("#holdings ul.single-link a").tooltip({placement : 'right'});
  $("#holdings button.link-type-fulltext").tooltip({placement : 'right'});
  $("#documents ul.single-link a").tooltip({placement : 'right'});
  $("#documents button.link-type-fulltext").tooltip({placement : 'right'});

  /* enable tooltips */
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  });



  /* check if a user is touching their device */
  window.addEventListener('touchstart', function onFirstTouch() {

    /* turn off tooltips */
    $('[data-toggle="tooltip"]').tooltip('destroy');

    /* turn off staff hover */
    $("#content .items .staff-view-toggle-wrapper").css({ "display":"block" });

    /* make location buttons larger */
    $("#holdings .items .location-modal-toggle").addClass('touch-enabled');
    $("#documents .items .location-modal-toggle").addClass('touch-enabled');


    window.removeEventListener('touchstart', onFirstTouch, false);
  }, false);


  // add border to non-empty previousNextDocument
  if ($("#previousNextDocument div").length) {
    $("#previousNextDocument").addClass('border');
  }


  /* When the Request button is clicked for a TRLN result, show */
  /* a modal with links to choose your home library. Add the    */
  /* corresponding ILLiad request parameters to those links.    */

  $(document).on("click", ".request-from-trln", function () {
    var $req_button = $(this);
    var illiad_params = $req_button.data('illiad-params');
    $( "#choose-your-illiad a" ).each(function(){
      new_href = ($(this).data('base-url') + '?' + illiad_params);
      $(this).attr( "href", new_href );
      /* pass the doc ID on to the link for analytics */
      $(this).data('document-id',
        ($req_button.closest('[data-document-id]').data('document-id') ||
          $('#document').data('document-id')));
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

  /* if this is a trln-context show page */
  if ( $('body').hasClass('blacklight-trln-show') ) {
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
          var myParent = $( "#item-" + escape_id(id) );
          var mySpan = $( "#item-" + escape_id(id) + " dl dd span" );

          // error handling for non-matching items OR already updated items
          if ( mySpan.text() == "" || myParent.hasClass('status-updated') ) {
            return true;
          } else {

            /* update status text */
            if ( mySpan.text().trim() !== status.label.trim() ) {

              // add class to parent so as to identify this item as having been updated
              myParent.addClass('status-updated');

              mySpan
                // uses velocity.js for fade animation (much faster than jquery)
                .velocity("fadeOut", {
                  duration: 500,
                  complete: function() {
                    mySpan.text(status.label)
                  }
                })
                .velocity("fadeIn", { delay: 250,
                                      duration: 500,
                                      begin: function() {

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

            }

          }

        });
      };

    };

    xmlhttp.open("GET", api_url + document_id, true);
    xmlhttp.send();

  };



  /* Fix duplicate bookmark IDs on show pages */
  var theBookmarkPath = ".blacklight-catalog-show #show-sidebar-inner div.toggle_bookmark ";
  var theBookmarkID = $(theBookmarkPath + 'label').attr('for') + '_2';
  $(theBookmarkPath + 'label').attr('for', theBookmarkID);
  $(theBookmarkPath + 'label .toggle_bookmark').attr('id', theBookmarkID);

});


/* Add classes to the search results titles depending on whether they have */
/* thumbnails, request buttons, both, or neither. Fade the request button */
/* in once its final position is known, to prevent it from hopping after it */
/* is initially rendered. */

Blacklight.onLoad(function() {

  	$(window).load(function(){

      $('.document').each(function() {

        var hasRequest = $(this).has("div.index-document-functions").length;
        var hasWidth = $(this).children("div").find('img').get(0).naturalWidth;

        if (hasRequest && hasWidth > 2) {
          $(this).children(".documentHeader").addClass("has-request-and-thumbnail");
          $(this).children(".index-document-functions").css('opacity','1');
        }

        if (hasRequest && hasWidth < 2) {
          $(this).children(".documentHeader").addClass("has-request");
          $(this).children(".index-document-functions").css('opacity','1');
        }

        if (!hasRequest && hasWidth > 2) {
          $(this).children(".documentHeader").addClass("has-thumbnail");
        }

        if (!hasRequest && hasWidth < 2) {
          $(this).children(".documentHeader").addClass("no-request-nor-thumbnail");
        }

      });

    });

});