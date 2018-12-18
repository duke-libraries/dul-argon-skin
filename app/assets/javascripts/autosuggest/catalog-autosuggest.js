//  CATALOG AUTOSUGGEST FORM (FOR EXTERNAL SEARCH FORMS)
//  ====================================================
//  Note: data attributes set on the text input field
//		  and class set on the form
//  data-autosuggest-enabled="true"
//  data-autosuggest-path="https://find.library.duke.edu/suggest"
//
//  Also set on the text input field to disable native browser autocomplete:
//  autocomplete="off"

//  EXAMPLE MARKUP:
//  ---------------
//
//  <form class="catalog-search-form" action="https://find.library.duke.edu/">
//    <select name="search_field" id="search-field" class="search-field selectpicker" data-width="fit" data-style="btn-default search-select">
//      <option value="all_fields">All Fields</option>
//      <option value="title">Title</option>
//      <option value="author">Author</option>
//      <option value="subject">Subject</option>
//      <option value="isbn_issn">ISBN/ISSN/barcode</option>
//      <option value="shelfkey">Call Number (LC)</option></select>
//      <input type="text" data-autosuggest-enabled="true" data-autosuggest-path="https://find.library.duke.edu/suggest" name="q" style="width:600px;" autocomplete="off">
//      <input type="submit" value="Submit"></input>
//    </form>


jQuery(document).ready(function ($) {

  $('[data-autosuggest-enabled="true"]').each(function() {

    var $el = $(this);

    // Fetch the configured autosuggest path.
    var suggest_root = $el.data().autosuggestPath;

    // Identify the current form's scope toggle select
    var $scope_selector = $el.closest(".catalog-search-form").find("select").first();

    // Detect which search field is selected. Default to all_fields.
    var current_search_field = $scope_selector.val() || "all_fields";

    // Configure the request for title suggestions
    var titles = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: suggest_root + '?q=%QUERY',
        wildcard: '%QUERY',
        filter: function(response){
          return response.title;
        },
        replace: function(url, uri_encoded_query) {
          var new_url = suggest_root + '?q=' + uri_encoded_query;
          return new_url;
        }
      }
    });

    // Configure the request for author suggestions
    var authors = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: suggest_root + '?q=%QUERY',
        wildcard: '%QUERY',
        filter: function(response){
          return response.author;
        },
        replace: function(url, uri_encoded_query) {
          var new_url = suggest_root + '?q=' + uri_encoded_query;
          return new_url;
        }
      }
    });

    // Configure the request for subject suggestions

    var subjects = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: suggest_root + '?q=%QUERY',
        wildcard: '%QUERY',
        filter: function(response){
          return response.subject;
        },
        replace: function(url, uri_encoded_query) {
          var new_url = suggest_root + '?q=' + uri_encoded_query;
          return new_url;
        }
      }
    });

    // Set the typeahead options
    var options = {
      hint: true,
      highlight: true,
      minLength: 3
    };

    // Shared suggestion template
    function suggestion_template(data) {
      return '<p class="' + data.category + '"><span class="tt-category">' + data.category + '</span>' + data.term + '</p>';
    }

    // Set the typeahead datasets.

    var datasets = [];

    var dataset_title = {
      'name': 'titles',
      'displayKey': 'term',
      'source': titles.ttAdapter(),
      'templates': {
        'suggestion': function (data) {
          return suggestion_template(data);
        }
      }
    };

    var dataset_author = {
      'name': 'authors',
      'displayKey': 'term',
      'source': authors.ttAdapter(),
      'templates': {
        'suggestion': function (data) {
          return suggestion_template(data);
        }
      }
    };

    var dataset_subject = {
      'name': 'subjects',
      'displayKey': 'term',
      'source': subjects.ttAdapter(),
      'templates': {
        'suggestion': function (data) {
          return suggestion_template(data);
        }
      }
    };

    // Determine which dataset(s) should be queried
    // given the current search scope
    function field_datasets(current_search_field) {
      datasets = [];
      switch (current_search_field) {
        case 'title':
          datasets.push(dataset_title);
          break;
        case 'author':
          datasets.push(dataset_author);
          break;
        case 'subject':
          datasets.push(dataset_subject);
          break;
        case 'all_fields':
          datasets.push(dataset_title, dataset_author, dataset_subject);
          break;
      }
      return datasets;
    }

    // Listen for change to selected search field
    $scope_selector.on("change", function() {
      current_search_field = $(this).val();

      // Remove any existing .on() listeners attached to
      // typeahead:open. This prevents the listener from
      // switching the search field back to all fields at the
      // wrong time.
      $el.off('typeahead:open');

      // Generalized method for destroying and then
      // reinitializing the typeahead engine with a
      // different suggest URL.
      function reinit_typeahead(current_search_field) {
        $el.typeahead('destroy');
        $el.typeahead(options, field_datasets(current_search_field));
      }

      // Reinitialize the typeahead engine with the
      // suggest path set appropriately for the
      // currently selected search field.
      switch (current_search_field) {
        case 'title':
          reinit_typeahead('title');
          break;
        case 'author':
          reinit_typeahead('author');
          break;
        case 'subject':
          reinit_typeahead('subject');
          break;
        case 'all_fields':
          reinit_typeahead('all_fields');
          break;
        default:
          // If the selected search field is something other than
          // one of the above fields then destroy the typeahead engine.
          // We don't want to show it for ISBN search for example. It will
          // turn back on if another field is selected.
          $el.typeahead('destroy');
      }

      // Add any previously entered search back into
      // the typeahead widget.
      var prev_query = $el.typeahead('val');
      $el.typeahead('val', '').typeahead('val', prev_query);
    });

    // Detect when a typeahead suggestion is selected and
    // set the search field selector to the appropriate field
    // if the current field is all_fields.
    $el.on('typeahead:select', function(ev, data) {
      function switch_selected_field(field) {
        if ($scope_selector) {
          $scope_selector.val(field);
        }

        if ($.fn.selectpicker) {
          $('.selectpicker').selectpicker('refresh');
        }
      }

      if (current_search_field == 'all_fields') {
        switch_selected_field(data.category);

        // Listen for event that indicates the user changed their
        // mind and switch the selector back to all_fields.
        $el.on('typeahead:open', function(ev, data){
          switch_selected_field('all_fields');
        });
      }
    });

    // Initialize typeahead for only these fields.
    if (current_search_field == 'title' ||
        current_search_field == 'author' ||
        current_search_field == 'subject' ||
        current_search_field == 'all_fields') {

          $el.typeahead(options, field_datasets(current_search_field));
    }
  });
});
