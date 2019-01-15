# frozen_string_literal: true

module SubjectsBoost
  extend ActiveSupport::Concern

  # A hack to deal with the fact that
  # non-Roman subjects like to come up first
  # since linked fields often duplicate English
  # language subjects.
  def subjects_boost(solr_parameters)
    return unless includes_subject_search?
    solr_parameters[:bq] ||= []
    solr_parameters[:bq] << subjects_english_boost_query
    solr_parameters[:bq] << subjects_title_boost_query
    solr_parameters[:bf] ||= []
    solr_parameters[:bf] << subjects_recent_boost_function
  end

  private

  def subjects_recent_boost_function
    "linear(recip(rord(#{TrlnArgon::Fields::DATE_CATALOGED_FACET})"\
    ',1,1000,1000),11,0)^500'
  end

  def subjects_english_boost_query
    "#{TrlnArgon::Fields::LANGUAGE_FACET}:English^1000"
  end

  def subjects_title_boost_query
    if blacklight_params.key?(:q) &&
       blacklight_params[:q].present?
      standard_search_title_boost
    elsif blacklight_params.key?('subject') &&
          blacklight_params['subject'].present?
      advanced_search_title_boost
    end
  end

  def standard_search_title_boost
    "#{TrlnArgon::Fields::TITLE_MAIN_INDEXED}:"\
    "(#{RSolr.solr_escape(blacklight_params[:q])})^500"
  end

  def advanced_search_title_boost
    "#{TrlnArgon::Fields::TITLE_MAIN_INDEXED}:"\
    "(#{RSolr.solr_escape(blacklight_params['subject'])})^500"
  end

  def includes_subject_search?
    blacklight_params.key?('search_field') &&
      ((blacklight_params['search_field'] == 'subject' ||
      blacklight_params['search_field'] == 'genre_headings') ||
      (blacklight_params['search_field'] == 'advanced' &&
      blacklight_params.fetch('subject', nil).present?))
  end
end
