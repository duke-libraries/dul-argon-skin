/*

BLACKLIGHT CATALOG NEW ADDITIONS WIDGET
===========================
Prints a linked list of newly cataloged items matching a Blacklight query.

  EXAMPLE MARKUP:

  <h2>
    <a href="..." class="new-additions-heading" data-type="duke_authors">New From Duke Authors</a>
    <span id="count-catalog-feed-items-duke_authors"></span> <!-- optional -->
  </h2>
  <ul id="catalog-feed-items-duke_authors" class="new-additions"
   data-query="f%5Blocation_hierarchy_f%5D%5B%5D=duke%3Adukeperk%3Adukeperkdurs"
   data-type="duke_authors" data-fetchresults="10">
    <li class="placeholder">...</li>
    <li class="placeholder">...</li>
    <li class="placeholder">...</li>
    <li class="placeholder">...</li>
    <li class="placeholder">...</li>
  </ul>

*/

jQuery(document).ready(function ($) {

  function shorten(text, maxLength) {
      var ret = text;
      if (ret.length > maxLength) {
          ret = ret.substr(0,maxLength-3) + "...";
      }
      return ret;
  }

  function find_author(obj) {
    if(obj.hasOwnProperty('statement_of_responsibility_a')) {
      return obj.statement_of_responsibility_a[0];
    }
    else {
      return "";
    }
  }

  function build_thumb(obj) {
    thumb_url = 'https://syndetics.com/index.aspx?isbn=';
    if(obj.hasOwnProperty('isbn_number_a')) {
      thumb_url += obj.isbn_number_a[0];
    }
    thumb_url += '/LC.GIF&upc=';
    if(obj.hasOwnProperty('upc_a')) {
      thumb_url += obj.upc_a[0].replace('UPC: ','');
    }
    thumb_url += '&oclc=';
    if(obj.hasOwnProperty('oclc_number')) {
      thumb_url += obj.oclc_number;
    }
    thumb_url += '&client=trlnet';
    return thumb_url;
  }

  function find_description(obj) {
    if(obj.hasOwnProperty('note_summary_a')) {
      // Replace quotes in note--they mess things up
      return shorten(obj.note_summary_a[0],100).replace(/"/g, "'");
    }
    else {
      return "";
    }
  }

  var catalog_base_url = 'https://find.library.duke.edu';

  $("[id^=catalog-feed-items]").each(function(){
    var $this_widget = $(this);
    var widget_id = $this_widget.attr('id');
    var blacklight_query = $this_widget.data('query');
    var fetchresults = parseInt($this_widget.data('fetchresults')) || 20;
    var showitems = parseInt($this_widget.data('showitems'));
    var showcount = $this_widget.data('showcount');

    // Fallback behavior in case there's a problem loading the data or if the
    // query returns no matching items...
    function fallbackToLink($this_widget) {
      $this_widget.html('');
      $this_widget.append('<li>Explore these items using the link above.</li>');
    }

    // Check whether all of the widget's thumbnail load attempts have completed; if so,
    // add a class to any remaining thumb placeholders to mark them as definitively empty.
    function thumbChecksComplete($this_widget, possible_thumbs, checked_thumbs) {
      if (checked_thumbs == possible_thumbs) {
        $this_widget.find("li.placeholder").addClass("placeholder-empty");
      }
    }

    $.ajax({
      url: catalog_base_url + '/catalog.json?sort=date_cataloged+desc%2C+publication_year_isort+desc&amp;'
        + 'per_page=' + fetchresults + '&amp;' + blacklight_query,
      type: "GET",
      dataType: 'json',
      success: function (data) {

        // Get total result count for query
        var total_results = data.response.pages.total_count.toString();

        // Prettify with commas
        var result_count = total_results.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");

        // Add the result count to an element on the page (if exists)
        $('#count-'+widget_id).html(result_count);

        // Start tallying how many items' thumbs have been checked and
        // how many have successfully returned good thumbs
        var checked_thumbs = 0;
        var good_thumbs = 0;
        var possible_thumbs = data.response.docs.length;

        // If the query returned no items for any reason...
        if(possible_thumbs == 0) {
          fallbackToLink($this_widget);
        }

        // Iterate through the items & map the properties of interest
        $.each(data.response.docs, function(idx, obj) {
          var item = {};

          item = {
            title:        obj.title_main || "[Untitled]",
            link:         catalog_base_url + '/catalog/' + obj.local_id,
            author:       find_author(obj),
            description:  find_description(obj),
            thumb:        build_thumb(obj),
          }

          var $item_link_markup = $('<a />').attr('href', item.link)
                                            .attr('title', item.description)
                                            .attr('class', 'new-additions-link');
          var $item_title_markup = '<div class="new-additions-title">' + item.title + '</div>';
          var $item_info_markup = '<div class="muted small new-additions-author">' + item.author + '</div>';


          // Check that the thumbnail is actually present / legitimate
          // Once this src is set, the image begins loading -- no turning back
          var $thumb_img = $("<img />").attr('src', item.thumb).attr('class','new-additions-thumb').attr('alt', 'cover image');

          // When this image load attempt is complete (note: b/c asynchronous loading, the thumbs
          // may render in slightly different order w/each pageview)...
          $thumb_img.on('load', function() {

              if (!this.complete || typeof this.naturalWidth == "undefined" || this.naturalWidth < 0) {
                // This item's thumb is no good.
                checked_thumbs++;
                thumbChecksComplete($this_widget, possible_thumbs, checked_thumbs);
              } else {
                // It's a good thumb; use this item.
                good_thumbs++;

                // Put this item and its thumb in the correct spot in the row.
                $this_item = $this_widget.find("li:nth-child("+good_thumbs+")");

                $this_item.html(""); // clear out the skeleton markup
                $this_item.removeClass("placeholder");
                $item_link_markup.prepend($thumb_img);
                $item_link_markup.append($item_title_markup);
                $this_item.append($item_link_markup);
                $this_item.append($item_info_markup);

                checked_thumbs++;
                thumbChecksComplete($this_widget, possible_thumbs, checked_thumbs);
              }
          })
          .on('error', function() {
            // This item's thumb is no good
            checked_thumbs++;
            thumbChecksComplete($this_widget, possible_thumbs, checked_thumbs);
          });

        }); // end document iterator

      }, // end success
      error: function(){
        fallbackToLink($this_widget);
      } // end error
    }); // end .ajax({})

  }); // end #catalog-feed-items* iterator
});
