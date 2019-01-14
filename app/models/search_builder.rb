# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder

  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include TrlnArgon::ArgonSearchBuilder
  include DulArgonSkin::ShelfkeySearchBuilder
  include DulArgonSkin::EnglishSubjectsBoost

  self.default_processor_chain += %i[add_advanced_search_to_solr
                                     add_shelfkey_query_to_solr
                                     english_subjects_boost]

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end
end
