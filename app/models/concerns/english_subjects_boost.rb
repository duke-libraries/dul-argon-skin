# frozen_string_literal: true

module EnglishSubjectsBoost
  extend ActiveSupport::Concern

  # A hack to deal with the fact that
  # non-Roman subjects like to come up first
  # since linked fields often duplicate English
  # language subjects.
  def english_subjects_boost(solr_parameters)
    return unless includes_subject_search?
    solr_parameters[:bq] = 'language_f:English^10000'
  end

  private

  def includes_subject_search?
    blacklight_params.key?('search_field') &&
      (blacklight_params['search_field'] == 'subject' ||
      (blacklight_params['search_field'] == 'advanced' &&
      blacklight_params.fetch('subject', nil).present?))
  end
end
