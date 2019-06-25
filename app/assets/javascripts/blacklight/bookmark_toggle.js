/* ++ Overrides default Blacklight file -- /app/assets/javascripts/blacklight/bookmark_toggle.js ++ */
/* ++ Includes DUL-version of checkbpx_submit.js (checkbox_submit_dul) ++ */

//= require blacklight/core
//= require blacklight/checkbox_submit_dul

(function($) {
//change form submit toggle to checkbox
    Blacklight.do_bookmark_toggle_behavior = function() {
      $(Blacklight.do_bookmark_toggle_behavior.selector).bl_checkbox_submit({
         //css_class is added to elements added, plus used for id base
         css_class: "toggle_bookmark",
         success: function(checked, response) {
           if (response.bookmarks) {
              if (response.bookmarks.count == 0) {
                $('[data-role=bookmark-counter]').text(response.bookmarks.count);
                $('#bookmarks_nav').hide();
              } else {
                $('[data-role=bookmark-counter]').text(response.bookmarks.count);
                $('#bookmarks_nav').show();
              }
           }
         }
      });
    };
    Blacklight.do_bookmark_toggle_behavior.selector = "form.bookmark_toggle"; 

Blacklight.onLoad(function() {
  Blacklight.do_bookmark_toggle_behavior();  
  if ( $('#bookmarks_nav span').first().text() != 0 ) {
    $('#bookmarks_nav').show();
  }
});
  

})(jQuery);
