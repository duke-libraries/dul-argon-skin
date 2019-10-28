# frozen_string_literal: true

class AdvancedController < CatalogController
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def index
    return if request.method == :post

    if (params.keys - %w[controller action]).empty?
      cache_key = "#{params.fetch('controller', '')}/"\
                  "#{params.fetch('action', '')}"\
                  'advanced_solr_query'
    end

    @response =
      if cache_key
        Rails.cache.fetch(cache_key.to_s, expires_in: 12.hours) do
          get_advanced_search_facets
        end
      else
        get_advanced_search_facets
      end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def search_action_url(options = {})
    url_for(options.merge(controller: 'catalog', action: 'index'))
  end

  # rubocop:disable AccessorMethodName
  # Method name is from BL Advanced Search
  def get_advanced_search_facets
    # We want to find the facets available for the current search, but:
    # * IGNORING current query (add in facets_for_advanced_search_form filter)
    # * IGNORING current advanced search facets
    #   (remove add_advanced_search_to_solr filter)
    response, = search_results(params) do |search_builder|
      search_builder.except(:add_advanced_search_to_solr)
                    .append(:facets_for_advanced_search_form)
    end

    response
  end
  # rubocop:enable AccessorMethodName
end
