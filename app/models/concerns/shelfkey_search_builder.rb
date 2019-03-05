# frozen_string_literal: true

module ShelfkeySearchBuilder
  extend ActiveSupport::Concern

  def add_shelfkey_query_to_solr(solr_parameters)
    return unless shelfkey_query_present?

    solr_parameters[:uf] = 'shelfkey'
    solr_parameters[:defType] = 'lucene'
    solr_parameters[:q] = shelfkey_query
  end

  private

  def shelfkey_query_present?
    blacklight_params.key?('search_field') &&
      blacklight_params['search_field'] == 'shelfkey' &&
      blacklight_params[:q].present? &&
      blacklight_params[:q].respond_to?(:to_str)
  end

  def normalized_shelfkey
    @normalized_shelfkey ||= Lcsort.normalize(blacklight_params[:q].to_s) ||
                             blacklight_params[:q].to_s
  end

  # Generate fielded regex query for Solr.
  # Regex fussiness at the end is to force the last
  # segment to match completely.
  def shelfkey_query
    "shelfkey:/lc:#{normalized_shelfkey.split('--').first}(\\..*|-.*)*/"
  end
end
