$(document).ready(function() {
  /* DUL masthead primary navigation menu toggle */
  $('a#full-menu-toggle').on('click',function(e) {
    $(this).toggleClass('menu-active');
    $('#dul-masthead-region-megamenu').slideToggle();
  });
});
