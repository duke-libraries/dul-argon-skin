/* ========================================================= */
/* Scripts used by the Style Guide page.                     */
/* NOTE: these load & execute on all pages. Consider whether */
/* to include this only within the styleguide template.      */
/* ========================================================= */

/* Get hex color from RGB. css('background-color') returns e.g. rgb(4, 52, 130) */
/* See https://stackoverflow.com/a/1740716 */
function rgb2hex(rgb) {
  if (/^#[0-9A-F]{6}$/i.test(rgb)) return rgb;

  rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
  function hex(x) {
    return ("0" + parseInt(x).toString(16)).slice(-2);
  }
  return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
}

/* Determine RGB color's luminance & contrast */
/* See https://stackoverflow.com/a/9733420 */
function luminance(r, g, b) {
  var a = [r, g, b].map(function (v) {
    v /= 255;
    return v <= 0.03928
      ? v / 12.92
      : Math.pow( (v + 0.055) / 1.055, 2.4 );
  });
  return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
}

function contrast(rgb1, rgb2) {
  var luminance1 = luminance(rgb1[0], rgb1[1], rgb1[2]) + 0.05;
  var luminance2 = luminance(rgb2[0], rgb2[1], rgb2[2]) + 0.05;
  return luminance1 / luminance2;
}

$(document).ready(function(){

  /* Find and display hex values and contrast ratings for each color swatch. */
  $('.color-swatch').each(function(){

    var rgb = $(this).find('.color-block').css('background-color');

    var rgb_no_space = rgb.split(" ").join("");
    var rgb_regexp = /^rgb\((\d+),(\d+),(\d+)\)$/g;
    var match = rgb_regexp.exec(rgb_no_space);

    var red = match[1];
    var green = match[2];
    var blue = match[3];

    var white_contrast_float = contrast([255,255,255],[red,green,blue]);
    var black_contrast_float = contrast([red,green,blue],[0,0,0]);

    var white_contrast = Math.round( white_contrast_float * 10 ) / 10;
    var black_contrast = Math.round( black_contrast_float * 10 ) / 10;

    /* Put the hex color in the box */
    $(this).find('.color-block.show-hex').text(rgb2hex(rgb));

    /* Add black and white contrast ratio */
    $(this).find('.contrast-score-black').text(black_contrast);
    $(this).find('.contrast-score-white').text(white_contrast);

    /* Change hex text to white or black--whichever has better contrast */
    if (white_contrast > black_contrast) {
      $(this).find('.color-block').css('color','white');
    }


    /* Color-code the contrast scores for WCAG2.0 rating */
    if (white_contrast >= 4.5) {
      $(this).find('.contrast-score-white').addClass('contrast-score-pass');
    } else if (white_contrast >= 3 && white_contrast < 4.5) {
      $(this).find('.contrast-score-white').addClass('contrast-score-warn');
    } else {
      $(this).find('.contrast-score-white').addClass('contrast-score-fail');
    }

    if (black_contrast >= 4.5) {
      $(this).find('.contrast-score-black').addClass('contrast-score-pass');
    } else if (black_contrast >= 3 && black_contrast < 4.5) {
      $(this).find('.contrast-score-black').addClass('contrast-score-warn');
    } else {
      $(this).find('.contrast-score-black').addClass('contrast-score-fail');
    }
  });

  /* Report font styles for body copy */

  $('#styleguide-body-font').text($('body').css('font-family'));
  $('#styleguide-body-size').text($('body').css('font-size'));
  $('#styleguide-body-color').text(rgb2hex($('body').css('color')));
  $('#styleguide-body-lineheight').text($('body').css('line-height'));


});
