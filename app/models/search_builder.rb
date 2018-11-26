# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder

  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include TrlnArgon::ArgonSearchBuilder

  self.default_processor_chain += %i[add_advanced_search_to_solr
                                     add_shelfkey_query_to_solr]

  def add_shelfkey_query_to_solr(solr_parameters)
    return unless shelfkey_query_present?
    solr_parameters[:q] = '{!edismax qf=shelfkey_t pf=shelfkey_t}'\
                          "lc\\:#{Lcsort.normalize(blacklight_params[:q].to_s)}"
    solr_parameters[:defType] = 'lucene'
  end

  private

  def shelfkey_query_present?
    blacklight_params.key?('search_field') &&
      blacklight_params['search_field'] == 'shelfkey' &&
      blacklight_params[:q].present? &&
      blacklight_params[:q].respond_to?(:to_str)
  end

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end
end
