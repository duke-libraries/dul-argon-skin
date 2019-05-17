# frozen_string_literal: true

class CatalogController < ApplicationController
  include BlacklightRangeLimit::ControllerOverride
  include Blacklight::Catalog

  # CatalogController behavior and configuration for TrlnArgon
  include TrlnArgon::ControllerOverride

  configure_blacklight do |config|
    # Switched index partial order so text can wrap around the thumbnail
    # NOTE: index_document_actions_default is a custom DUL partial
    config.index.partials =
      %i[thumbnail index_document_actions index_header index index_items]

    # Add Request button using Blacklight's extensible "tools" for
    # index view
    config.add_results_document_tool(:request_button, partial: 'request_button')

    # Add RSS feed button using Blacklight's extensible "collection tools"
    # for index view.
    # NOTE: rss_button is a custom DUL partial
    config.add_results_collection_tool(:rss_button, partial: 'rss_button')

    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request params
    #  for the search index config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests.
    #  See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 10,
      lowercaseOperators: 'false' # https://issues.apache.org/jira/browse/SOLR-4646
    }

    config.advanced_search[:form_solr_parameters] = {
      # NOTE: You will not get any facets back
      #       on the advanced search page
      #       unless defType is set to lucene.
      'defType' => 'lucene',
      'facet.field' => [TrlnArgon::Fields::AVAILABLE_FACET.to_s,
                        TrlnArgon::Fields::ACCESS_TYPE_FACET.to_s,
                        TrlnArgon::Fields::RESOURCE_TYPE_FACET.to_s,
                        TrlnArgon::Fields::PHYSICAL_MEDIA_FACET.to_s,
                        TrlnArgon::Fields::LANGUAGE_FACET.to_s,
                        TrlnArgon::Fields::LOCATION_HIERARCHY_FACET.to_s],
      'f.resource_type_f.facet.limit' => -1, # return all resource type values
      'f.language_f.facet.limit' => -1, # return all language facet values
      'f.location_hierarchy_f.facet.limit' => -1, # return all loc facet values
      'f.physical_media_f.facet.limit' => -1, # return all phys med facet values
      'facet.limit' => -1, # return all facet values
      'facet.sort' => 'index', # sort by byte order of values
      'facet.query' => ''
    }

    # solr path which will be added to solr base url before other solr params
    # config.solr_path = 'select'

    # items to show per page, each number in the array represent another
    # option to choose from.
    # config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr.
    # These settings are the BL defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    # config.default_document_solr_params = {
    #  qt: 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # fl: '*',
    #  # rows: 1,
    #  # q: '{!term f=id v=$id}'
    # }

    # solr field configuration for search results/index views
    # config.index.thumbnail_field = 'thumbnail_path_ss'

    # solr field configuration for document/show views
    # config.show.title_field = 'title_display'
    # config.show.display_type_field = 'format'
    # config.show.thumbnail_field = 'thumbnail_path_ss'

    config.home_facet_fields.delete(TrlnArgon::Fields::AVAILABLE_FACET)
    config.facet_fields.delete(TrlnArgon::Fields::AVAILABLE_FACET)

    # Temporarily disable slow facets on home page until caching is
    # enabled in TRLN Argon.
    config.home_facet_fields.delete(TrlnArgon::Fields::CALL_NUMBER_FACET)
    config.home_facet_fields.delete(TrlnArgon::Fields::LANGUAGE_FACET)

    # Delete but save date cataloged facet so we can add it again
    # in the last position.
    date_cataloged = config.home_facet_fields.delete(
      TrlnArgon::Fields::DATE_CATALOGED_FACET
    )
    config.add_home_facet_field TrlnArgon::Fields::PHYSICAL_MEDIA_FACET.to_s,
                                label: TrlnArgon::Fields::
                                       PHYSICAL_MEDIA_FACET.label,
                                limit: true,
                                collapse: false
    config.add_home_facet_field date_cataloged

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have
    # facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate
    # alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to
    # create the navigation (note: It is case sensitive when searching values)

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? Set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('shelfkey') do |field|
      field.label = I18n.t('trln_argon.search_fields.shelfkey')
      field.advanced_parse = false
      field.include_in_advanced_search = false
    end

    # Delete but save isbn_issn search_field config
    # so we can add it again in the last position.
    isbn_issn = config.search_fields.delete('isbn_issn')

    config.add_search_field('series_statement') do |field|
      field.include_in_simple_select = false
      field.label = I18n.t('trln_argon.search_fields.series')
      field.def_type = 'edismax'
      field.solr_local_parameters = {
        qf:  %w[series_work_indexed_t^20
                series_work_indexed_ara_v
                series_work_indexed_cjk_v
                series_work_indexed_rus_v
                series_statement_indexed_t^20
                series_statement_indexed_cjk_v
                series_statement_indexed_ara_v
                series_statement_indexed_rus_v].join(' '),
        pf:  %w[series_work_indexed_t^80
                series_work_indexed_ara_v^20
                series_work_indexed_cjk_v^20
                series_work_indexed_rus_v^20
                series_statement_indexed_t^80
                series_statement_indexed_cjk_v^20
                series_statement_indexed_ara_v^20
                series_statement_indexed_rus_v^20].join(' '),
        pf3: %w[series_work_indexed_t^60
                series_work_indexed_ara_v^10
                series_work_indexed_cjk_v^10
                series_work_indexed_rus_v^10
                series_statement_indexed_t^60
                series_statement_indexed_cjk_v^10
                series_statement_indexed_ara_v^10
                series_statement_indexed_rus_v^10].join(' '),
        pf2: %w[series_work_indexed_t^40
                series_work_indexed_ara_v^5
                series_work_indexed_cjk_v^5
                series_work_indexed_rus_v^5
                series_statement_indexed_t^40
                series_statement_indexed_cjk_v^5
                series_statement_indexed_ara_v^5
                series_statement_indexed_rus_v^5].join(' ')
      }
    end

    config.add_search_field(isbn_issn)

    config.add_show_field TrlnArgon::Fields::LOCAL_ID.to_s,
                          label: 'System ID',
                          helper_method: 'strip_duke_id_prefix'

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).

    config.add_sort_field "#{TrlnArgon::Fields::DATE_CATALOGED} desc, "\
                          "#{TrlnArgon::Fields::PUBLICATION_YEAR_SORT} desc",
                          label: \
                          I18n.t('trln_argon.sort_options.date_cataloged_desc')

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    # config.autocomplete_enabled = false
    # config.autocomplete_path = 'suggest'
  end
end
